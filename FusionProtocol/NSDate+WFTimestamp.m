//
//  NSDate+WFTimestamp.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "NSDate+WFTimestamp.h"

@implementation NSDate (WFTimestamp)

+ (id)dateFromTimestamp:(WFTimestamp)timestamp
{
    if (timestamp == WFTimestampDistantFuture)
        return [NSDate distantFuture];
    else
        return [NSDate dateWithTimeIntervalSince1970:WFTimeIntervalFromTimestamp(timestamp)];
}

- (WFTimestamp)timestamp
{
    if ([self isEqualToDate:[NSDate distantFuture]])
        return WFTimestampDistantFuture;
    else
        return WFTimestampFromTimeInterval([self timeIntervalSince1970]);
}

- (NSString *)displayTime
{
    NSTimeInterval timeDifference = fabs([self timeIntervalSinceNow]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:(timeDifference > 43200) ? NSDateFormatterLongStyle : NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:(timeDifference > 43200) ? NSDateFormatterNoStyle : NSDateFormatterShortStyle];
    
    return
    (timeDifference < 60) ?
        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%.0lf sec",
                                                                      @"ui",
                                                                      WFThisBundle,
                                                                      @""
                                                                      ), timeDifference] :
    (timeDifference < 3600) ?
        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%.1lf min",
                                                                      @"ui",
                                                                      WFThisBundle,
                                                                      @""
                                                                      ), timeDifference / 60] :
    (timeDifference < 10800) ?
        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"%.1lf hr",
                                                                      @"ui",
                                                                      WFThisBundle,
                                                                      @""
                                                                      ), timeDifference / 3600] :
    [dateFormatter stringFromDate:self];
    // NB: I tried indention hard to make sure this shows easily.
}

@end
