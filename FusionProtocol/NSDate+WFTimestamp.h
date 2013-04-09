//
//  NSDate+WFTimestamp.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

WFBeginDecls

typedef int64_t WFTimestamp;

NS_INLINE WFTimestamp WFTimestampFromTimeInterval(NSTimeInterval timeInterval)
{
    return timeInterval * 1000;
}

NS_INLINE NSTimeInterval WFTimeIntervalFromTimestamp(WFTimestamp timestamp)
{
    return (NSTimeInterval)timestamp / 1000.0;
}

#define WFTimestampDistantFuture (-1000LL)

@interface NSDate (WFTimestamp)

+ (id)dateFromTimestamp:(WFTimestamp)timestamp;
- (WFTimestamp)timestamp;

- (NSString *)displayTime;

@end

WFEndDecls
