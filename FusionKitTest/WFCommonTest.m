//
//  WFCommonTest.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFCommonTest.h"
#import <FusionKit/FusionKit.h>

@implementation WFCommonTest

- (void)testTimestamp
{
    STAssertEquals(WFTimeIntervalFromTimestamp(50000), 50.0, @"");
    STAssertEquals(WFTimestampFromTimeInterval(2.0), (WFTimestamp)2000, @"");
}

@end
