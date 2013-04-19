//
//  WFCommonTest.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFCommonTest.h"
#import <FusionKit/FusionKit.h>
#import <FusionProtocol/FusionProtocol.h>

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

- (void)testObjectSerializing
{
    WFLogin *login = nil;
    NSDictionary *dictionary = @{@"user": @"foo", @"pass": @"bar"};
    STAssertNotNil(login = [[WFLogin alloc] init], @"");
    login.user = @"foo";
    login.pass = @"bar";
    STAssertTrue([[login dictionaryRepresentation] isEqualToDictionary:dictionary], @"");
}

- (void)testMethodForwarding
{
    NSDictionary *deserializing = @{@"user": @"foo", @"pass": @"bar"};
    WFLogin *login = nil;
    WFWrapper *result = nil;
    STAssertNotNil(login = [[WFLogin alloc] initWithDictionary:deserializing], @"");
    STAssertNotNil(result = [login login], @"");
    STAssertTrue([result isKindOfClass:[WFWrapper class]], @"");
    STAssertNotNil(result.d, @"");
    NSLog(@"Result: %@.", result.d);
}

- (void)testObjectData
{
    WFObject *object = [[WFObject alloc] init];
    WFNull *null = [WFNull null];
    
    NSDictionary *defaultDictionary = [object dictionaryRepresentation];
    NSDictionary *nullDictionary = [null dictionaryRepresentation];
    
    STAssertEqualObjects(defaultDictionary, @{}, @"");
    STAssertTrue(nullDictionary == nil, @"");
}

@end
