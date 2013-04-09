//
//  WFConnection.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFConnection.h"
#import "WFConstants.h"
#import "WFTypes.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation WFObject (WFSending)

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL method = [anInvocation selector];
    Class class = [self classForMethod:method];
    id value = nil;
    
    do
    {
        NSMutableString *methodName = [NSStringFromSelector(method) mutableCopy];
        [methodName replaceOccurrencesOfString:@":"
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [methodName length])];
        [methodName replaceCharactersInRange:NSMakeRange(0, 1)
                                  withString:[[methodName substringToIndex:1] uppercaseString]];
        
        //WFLog(@"Object %@ sending method %@ to server.", NSStringFromClass([self class]), methodName);
        
        NSError *error = nil;
        NSData *uplinkData = [self JSONDataWithError:&error];
        
        if (!uplinkData)
        {
            value = error;
            break;
        }
        error = nil;
        
        NSData *downlinkData = [[WFConnection connection] dataWithData:uplinkData
                                                            fromMethod:methodName
                                                                 error:&error];
        
        if (!downlinkData)
        {
            value = error;
            break;
        }
        error = nil;
        
        id downlinkObject = [NSJSONSerialization JSONObjectWithData:downlinkData
                                                            options:0
                                                              error:&error];
        
        if (!downlinkObject)
        {
            value = error;
            break;
        }
        error = nil;
        
        value = downlinkObject;
        if (class && [class isSubclassOfClass:[WFObject class]])
        {
            if ([downlinkObject isKindOfClass:[NSDictionary class]])
            {
                value = [[class alloc] initWithDictionary:downlinkObject];
            }
            else if ([downlinkObject isKindOfClass:[NSArray class]])
            {
                NSArray *array = downlinkObject;
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
                for (id item in array)
                {
                    if ([item isKindOfClass:[NSDictionary class]])
                    {
                        [mutableArray addObject:[[class alloc] initWithDictionary:item]];
                    }
                    else
                    {
                        NSLog(@"WARNING: Object typed %@ occured in array asking for objects typed %@.", NSStringFromClass([item class]), NSStringFromClass(class));
                        [mutableArray addObject:item];
                    }
                }
                value = [mutableArray copy];
            }
        }
        
    } while (0);
    
    CFRetain((__bridge CFTypeRef)(value));
    [anInvocation setReturnValue:&value];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector])
        return [super methodSignatureForSelector:aSelector];
    else
    {
        NSString *signature = WFSTR(@"@@:");
        return [NSMethodSignature signatureWithObjCTypes:[signature cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    }
}

- (Class)classForMethod:(SEL)method
{
    NSMutableString *methodName = [NSStringFromSelector(method) mutableCopy];
    [methodName replaceOccurrencesOfString:@":"
                                withString:@""
                                   options:0
                                     range:NSMakeRange(0, [methodName length])];
    [methodName replaceCharactersInRange:NSMakeRange(0, 1)
                              withString:[[methodName substringToIndex:1] uppercaseString]];
    
    NSString *queryMethodName = WFSTR(@"classForMethod%@", methodName);
    SEL querySelector = NSSelectorFromString(queryMethodName);
    Class class = Nil;
    
    if ([self respondsToSelector:querySelector])
        class = objc_msgSend(self, querySelector);
    
    return class;
}

@end

static WFConnection *WFConn;

@implementation WFConnection

- (id)init
{
    if (self = [super init])
    {
        self.serverRoot = [NSURL URLWithString:@"https://www.shisoft.net/ajax/"];
    }
    return self;
}

+ (WFConnection *)connection
{
    if (!WFConn)
        WFConn = [[WFConnection alloc] init];
    return WFConn;
}

- (NSData *)dataWithData:(NSData *)data fromMethod:(NSString *)method error:(NSError *__autoreleasing *)error
{
    NSURL *methodURL = [NSURL URLWithString:method relativeToURL:self.serverRoot];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:methodURL];
    
    if ([data length])
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
    }
    
    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    
    if (![responseData length])
    {
        WFAssignPointer(error, err);
        return nil;
    }
    
    if ([response statusCode] >= 400)
    {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(WFSTR(@"http%ld", [response statusCode]),
                                                                          @"error",
                                                                          WFThisBundle,
                                                                          @"")
                                   };
        err = [NSError errorWithDomain:WFErrorDoamin
                                  code:[response statusCode]
                              userInfo:userInfo];
        WFAssignPointer(error, err);
        return nil;
    }
    
    return responseData;
}

- (NSString *)userAgent
{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSArray *OSNames = @[@"Unknown", @"Windows NT", @"Windows", @"Solaris", @"HP UX", @"OS X", @"Sun OS", @"OSF 1"];
    return WFSTR(@"FusionKit/4.0 (git version %@), %@, %@", WFVersion(), OSNames[[processInfo operatingSystem]], [processInfo operatingSystemVersionString]);
}

@end