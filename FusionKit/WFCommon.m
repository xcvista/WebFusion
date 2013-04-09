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
#import "WFObject.h"

WFStaticStringValue(WFDefaultKey, @"d");
WFStaticStringValue(WFDefaultTrueValue, @"+");
WFStaticStringValue(WFDefaultFalseValue, @"-");
WFStaticStringValue(WFErrorDoamin, @"info.maxchan.webfusion-v4");

NSString *WFVersion(void)
{
    NSBundle *bundle = WFFrameworkBundle();
    NSDictionary *gitVersion = [NSDictionary dictionaryWithContentsOfURL:[bundle URLForResource:@"git-version" withExtension:@"plist"]];
    return gitVersion[@"git-version"];
}

