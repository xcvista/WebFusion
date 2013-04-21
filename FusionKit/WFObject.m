//
//  WFObject.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFObject.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WFConstants.h"

@implementation WFObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        // Get a list of properties.
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        if (properties)
        {
            // Enumerate all properties.
            
            for (unsigned int i = 0; i < propertyCount; i++)
            {
                objc_property_t property = properties[i];
                NSString *name = @(property_getName(property));         // Property name.
                NSString *attr = @(property_getAttributes(property));   // Property attributes
                NSString *type = @"@";
                BOOL readonly = NO;
                
                // Check the property type.
                NSArray *attrs = [attr componentsSeparatedByString:@","];
                for (NSString *attribute in attrs)
                {
                    if ([attribute hasPrefix:@"R"])
                    {
                        readonly = YES;
                    }
                }
                
                id value = dictionary[name];                            // Find the value.
                
                if (!value && [name isEqualToString:@"ID"])
                {
                    value = dictionary[@"id"];                          // ID is used instead of id.
                }
                
                if (!readonly && value)
                {
                                                                        // Dispatching would require some tricks.
                    if ([type hasPrefix:WFType(id)])                    // Objects. Special requirements is required.
                    {
                        Class class = [self classForProperty:name];
                        id object = value;
                        
                        if (class && [class isSubclassOfClass:[WFObject class]])
                        {
                            if ([value isKindOfClass:[NSDictionary class]])
                                object = [[class alloc] initWithDictionary:value];
                            else if ([value isKindOfClass:[NSArray class]])
                            {
                                NSArray *array = value;
                                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
                                for (id item in array)
                                {
                                    if ([item isKindOfClass:[NSDictionary class]])
                                    {
                                        [mutableArray addObject:[[class alloc] initWithDictionary:item]];
                                    }
                                    else
                                    {
                                        [mutableArray addObject:item];
                                    }
                                }
                                object = [mutableArray copy];
                            }
                        }
                        value = object;
                    }
                    
                    @try
                    {
                        [self setValue:value forKey:name];
                    }
                    @catch (NSException *exception)
                    {
                        WFLog(@"WARNING: Cannot find property: %@", name);
                    }
                }
            }
            free(properties);
            properties = NULL;
        }
    }
    return self;
}

- (Class)classForProperty:(NSString *)property
{
    objc_property_t objcProperty = class_getProperty([self class], [property cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    NSString *attributes = @(property_getAttributes(objcProperty));
    NSString *type = @"@";
    Class class = Nil;
    
    NSString *methodName = WFSTR(@"classForProperty%@", [property stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                                                          withString:[[property substringToIndex:1] uppercaseString]]);
    SEL selector = NSSelectorFromString(methodName);
    if (selector && [self respondsToSelector:selector])
        class = objc_msgSend(self, selector);
    
    if (class)
        return class;
    
    NSArray *attrs = [attributes componentsSeparatedByString:@","];
    for (NSString *attribute in attrs)
    {
        if ([attribute hasPrefix:@"T"])
        {
            type = [attribute substringFromIndex:1];
        }
    }
    
    if ([type length] > 3)
    {
        NSString *className = [type substringWithRange:NSMakeRange(2, [type length] - 3)];
        class = NSClassFromString(className);
    }
    
    return class;
}

- (NSDictionary *)dictionaryRepresentation
{
    // Get a list of properties.
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
    
    if (properties)
    {
        // Enumerate all properties.
        
        for (unsigned int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            NSString *name = @(property_getName(property)); // Property name.
            
#if defined(GNUSTEP)                                        // For GNUstep, this _end property is handled.
            if ([name hasPrefix:@"_end"])
                continue;
#endif
            
            id value = nil;
            
            @try
            {
                value = [self valueForKey:name];            // Find the value, using KVO.
            }
            @catch (NSException *exception)
            {
                WFLog(@"WARNING: Cannot find key: %@", name);
            }
            
            if (!value)
            {
                continue;                                   // Ignore null keys.
            }
            
            if ([name isEqualToString:@"ID"])
            {
                name = @"id";                               // ID is used instead of id.
            }
            
            if ([value isKindOfClass:[WFObject class]])
            {
                value = [value dictionaryRepresentation];
            }
            else if ([value isKindOfClass:[NSArray class]])
            {
                NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity:[value count]];
                for (id object in value)
                {
                    if ([object isKindOfClass:[WFObject class]])
                    {
                        [outputArray addObject:[object dictionaryRepresentation]];
                    }
                    else
                    {
                        [outputArray addObject:object];
                    }
                }
            }
            
            dictionary[name] = value;
        }
        free(properties);
        properties = NULL;
    }
    return dictionary;
}

@end

@implementation WFObject (WFObjectJSON)

- (id)initWithJSONData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSError *err = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:0
                                                  error:&err];
    if (!object)
    {
        WFAssignPointer(error, err);
        return nil;
    }
    
    return [self initWithDictionary:object];
}

- (BOOL)canRepresentInJSON
{
    return [NSJSONSerialization isValidJSONObject:[self dictionaryRepresentation]];
}

- (NSData *)JSONDataWithError:(NSError *__autoreleasing *)error
{
    NSError *err = nil;
    NSDictionary *dict = [self dictionaryRepresentation];
    
    if (!dict)
    {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(@"err.noval", @"error", WFThisBundle, @"")
                                   };
        err = [NSError errorWithDomain:WFErrorDoamin
                                  code:1
                              userInfo:userInfo];
        WFAssignPointer(error, err);
        return nil;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self dictionaryRepresentation]
                                                   options:0
                                                     error:&err];
    
    if (!data)
    {
        WFAssignPointer(error, err);
        return nil;
    }
    
    return data;
}

@end

@implementation WFObject (WFEquality)

- (BOOL)isEqual:(id)object
{
    if ([self respondsToSelector:@selector(ID)] && [object respondsToSelector:@selector(ID)])
        return [[self ID] isEqual:[object ID]];
    else
        return [super isEqual:object];
}

@end
