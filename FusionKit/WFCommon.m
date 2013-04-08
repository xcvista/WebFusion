//
//  WFCommon.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFDecls.h"
#import "WFTypes.h"
#import "WFConstants.h"

#define WFCode 1

WFStaticStringValue(WFDefaultKey, @"d");
WFStaticStringValue(WFDefaultTrueValue, @"+");
WFStaticStringValue(WFDefaultFalseValue, @"-");

WFTimestamp WFTimestampFromTimeInterval(NSTimeInterval timeInterval)
{
    return timeInterval * 1000;
}

NSTimeInterval WFTimeIntervalFromTimestamp(WFTimestamp timestamp)
{
    return (NSTimeInterval)timestamp / 1000.0;
}

