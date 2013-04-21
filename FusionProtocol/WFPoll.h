//
//  WFPoll.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-20.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

@class WFPoll;

@protocol WFPollDataSource <NSObject>

@required
- (NSString *)pollName:(WFPoll *)poll;
- (NSDictionary *)pollCondition:(WFPoll *)poll;
- (void)poll:(WFPoll *)poll didFinishPollingWithResponse:(NSDictionary *)response;

@optional
- (void)pollDidStart:(WFPoll *)poll;
- (void)pollWillStop:(WFPoll *)poll;

@end

@interface WFPoll : NSObject

+ (WFPoll *)poll;

- (void)addTarget:(id<WFPollDataSource>)target;
- (void)removeTarget:(id<WFPollDataSource>)target;
- (void)removeTargetWithName:(NSString *)name;

- (void)start;
- (void)stop;

- (NSTimeInterval)waitTime;
- (void)setWaitTime:(NSTimeInterval)waitTime;

@end
