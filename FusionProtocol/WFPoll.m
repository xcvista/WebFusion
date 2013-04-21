//
//  WFPoll.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-20.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFPoll.h"

WFPoll *WFPollSingleton;

@implementation WFPoll
{
@private
    NSMutableDictionary *targets;
    NSTimeInterval wait;
    NSUInteger i;
    BOOL poll;
}

- (id)_init
{
    if (self = [super init])
    {
        targets = [NSMutableDictionary dictionary];
        poll = NO;
        wait = 10.0;
        i = 500;
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

- (void)_pollThread
{
    @autoreleasepool
    {
        // Due to the nature of WebFusion polling mechanism, this seemingly-tight
        // loop actually runs *very* slow.
        while (poll)
        {
            // Collect information from sources: synchronized over the targets variable.
            NSMutableArray *data = nil;
            @synchronized (targets)
            {
                data = [NSMutableArray arrayWithCapacity:[targets count]];
                for (NSString *name in targets)
                {
                    id<WFPollDataSource> source = targets[name];
                    NSMutableDictionary *cond = [[source pollCondition:self] mutableCopy];
                    cond[@"t"] = name;
                    [data addObject:cond];
                }
            }
            
            NSDictionary *uploadDictionary = []
            
        }
    }
}

- (void)start
{
    poll = YES;
    
    [self performSelectorInBackground:@selector(_pollThread) withObject:nil];
}

@end
