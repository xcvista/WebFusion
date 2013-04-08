//
//  WFWrapper.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFWrapper.h"
#import "WFConstants.h"

@implementation WFWrapper

- (BOOL)boolValue
{
    if ([self.d isEqual:WFDefaultTrueValue])
        return YES;
    return NO;
}

@end
