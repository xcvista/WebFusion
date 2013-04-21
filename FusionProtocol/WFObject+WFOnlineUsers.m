//
//  WFObject+WFOnlineUsers.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-21.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFObject+WFOnlineUsers.h"
#import "WFOnlineUser.h"

@implementation WFObject (WFOnlineUsersClass)

- (Class)classForMethodGetAliveUserContacts
{
    return [WFOnlineUser class];
}

@end
