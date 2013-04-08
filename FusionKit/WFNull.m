//
//  WFNull.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFNull.h"

@implementation WFNull

+ (WFNull *)null
{
    return [[self alloc] init];
}

- (NSDictionary *)dictionaryRepresentation
{
    return nil;
}

- (NSData *)JSONDataWithError:(NSError *__autoreleasing *)error
{
    return nil;
}

@end
