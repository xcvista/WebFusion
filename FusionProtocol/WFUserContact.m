//
//  WFUserContact.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-14.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFUserContact.h"
#import "WFUserContactMetadata.h"

@implementation WFUserContact

- (Class)classForPropertyUcs
{
    return [WFUserContactMetadata class];
}

@end
