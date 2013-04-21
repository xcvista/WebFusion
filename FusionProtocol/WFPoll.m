//
//  WFPoll.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-20.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFPoll.h"
#import "NSDate+WFTimestamp.h"

WFPoll *WFPollSingleton;

@interface WFPoll () <NSURLConnectionDataDelegate>

@property NSMutableDictionary *targets;
@property BOOL poll;
@property NSURLConnection *connection;
@property NSHTTPURLResponse *response;
@property NSMutableData *responseData;
@property NSUInteger dataSize;

@end

@implementation WFPoll

- (id)_init
{
    if (self = [super init])
    {
        self.targets = [NSMutableDictionary dictionary];
        self.poll = NO;
        self.wait = 10.0;
        self.interval = 0.5;
    }
    return self;
}

- (id)init
{
    if (!WFPollSingleton)
        WFPollSingleton = [self _init];
    return WFPollSingleton;
}

+ (WFPoll *)poll
{
    if (!WFPollSingleton)
        WFPollSingleton = [[self alloc] _init];
    return WFPollSingleton;
}

- (void)start
{
    self.poll = YES;
    
    // Collect information from sources: synchronized over the targets variable.
    NSMutableArray *conditions = nil;
    @synchronized (_targets)
    {
        conditions = [NSMutableArray arrayWithCapacity:[self.targets count]];
        for (NSString *name in self.targets)
        {
            id<WFPollDataSource> source = self.targets[name];
            NSMutableDictionary *cond = [[source pollCondition:self] mutableCopy];
            cond[@"t"] = name;
            [conditions addObject:cond];
        }
    }
    
    NSDictionary *uploadDictionary = @{
                                       @"d":    conditions,
                                       @"w":    @(WFTimestampFromTimeInterval(self.wait)),
                                       @"i":    @(WFTimestampFromTimeInterval(self.interval)),
                                       };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:uploadDictionary
                                                   options:0
                                                     error:NULL];
    
    NSMutableURLRequest *request = [[WFConnection connection] URLRequestForMethod:@"Poll"];
    
    if ([data length])
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        
        [request setValue:@"application/json;charset=utf-8"
       forHTTPHeaderField:@"Content-Type"];
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self.connection start];
    
}

- (void)stop
{
    self.poll = NO;
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.poll)
        [self start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = (NSHTTPURLResponse *)response;
    self.dataSize = [[self.response allHeaderFields][@"Content-Length"] unsignedIntegerValue];
    self.responseData = [NSMutableData dataWithCapacity:self.dataSize];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    
    if ([self.responseData length] >= self.dataSize)
    {
        // All data arrived. Lock and roll.
        NSData *data = [self.responseData subdataWithRange:NSMakeRange(0, self.dataSize)];
        self.responseData = nil;
        
        WFWrapper *wrapper = [[WFWrapper alloc] initWithJSONData:data
                                                           error:NULL];
        NSDictionary *responseInfo = wrapper.d;
        
        for (NSString *key in responseInfo)
        {
            id<WFPollDataSource> source = self.targets[key];
            [source poll:self didFinishPollingWithResponse:responseInfo[key]];
        }
    }
    
    if (self.poll)
        [self start];
}

- (void)addTarget:(id<WFPollDataSource>)target
{
    self.targets[[target pollName:self]] = target;
}

- (void)removeTarget:(id<WFPollDataSource>)target
{
    [self.targets removeObjectForKey:[target pollName:self]];
}

- (void)removeTargetWithName:(NSString *)name
{
    [self.targets removeObjectForKey:name];
}

@end
