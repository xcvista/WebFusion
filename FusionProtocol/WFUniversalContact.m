//
//  WFUniversalContact.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFUniversalContact.h"

@implementation WFUniversalContact

- (NSString *)displayName
{
    return
    ([self.scrName isEqualToString:self.dispName]) ? self.scrName :
    ([self.scrName length] == 0) ? self.dispName :
    ([self.dispName length] == 0) ? self.scrName :
    [NSString stringWithFormat:@"%@ (%@)", self.dispName, self.scrName];
}

- (NSURL *)avatarURL
{
    return [NSURL URLWithString:self.avatar];
}

@end
