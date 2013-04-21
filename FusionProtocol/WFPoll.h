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
- (void)poll:(WFPoll *)poll didFinishPollingWithResponse:(id)response;

@optional
- (void)pollDidStart:(WFPoll *)poll;
- (void)pollWillStop:(WFPoll *)poll;

@end

@interface WFPoll : NSObject

@property NSTimeInterval wait;
@property NSTimeInterval interval;

+ (WFPoll *)poll;

- (void)addTarget:(id<WFPollDataSource>)target;
- (void)removeTarget:(id<WFPollDataSource>)target;
- (void)removeTargetWithName:(NSString *)name;

- (void)start;
- (void)stop;

@end
