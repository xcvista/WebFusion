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

- (void)setUp
{
    NSLog(@"Testing WebFusion Version %@.", WFVersion());
}

- (void)testTimestamp
{
    STAssertEquals(WFTimeIntervalFromTimestamp(50000), 50.0, @"");
    STAssertEquals(WFTimestampFromTimeInterval(2.0), (WFTimestamp)2000, @"");
}

- (void)testObjectDeserializing
{
    NSDictionary *deserializing = @{@"user": @"foo", @"pass": @"bar"};
    WFLogin *login = nil;
    STAssertNotNil(login = [[WFLogin alloc] initWithDictionary:deserializing], @"");
    STAssertEqualObjects(login.user, @"foo", @"");
    STAssertEqualObjects(login.pass, @"bar", @"");
}

- (void)testMethodForwarding
{
    NSDictionary *deserializing = @{@"user": @"foo", @"pass": @"bar"};
    WFLogin *login = nil;
    STAssertNotNil(login = [[WFLogin alloc] initWithDictionary:deserializing], @"");
    STAssertTrueNoThrow([[login login] isKindOfClass:[NSError class]], @"");
}

@end
