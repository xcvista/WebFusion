//
//  WFLogin.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFLogin.h"

@implementation WFLogin

- (Class)classForMethodLogin
{
    return [WFWrapper class];
}

+ (BOOL)loginAsUser:(NSString *)username withPassword:(NSString *)password error:(NSError *__autoreleasing *)error
{
    WFLogin *login = [[WFLogin alloc] init];
    login.user = username;
    login.pass = password;
    id status = [login login];
    if ([status isKindOfClass:[WFWrapper class]])
        return [status boolValue];
    else if (status)
    {
        WFAssignPointer(error, status);
        return NO;
    }
    else
        return NO;
}

@end
