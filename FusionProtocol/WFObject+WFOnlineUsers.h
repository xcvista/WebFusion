//
//  WFObject+WFOnlineUsers.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-14.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

@interface WFObject (WFOnlineUsers)

@end

@interface WFObject (WFOnlineUsersQuery)

- (NSArray *)getAliveUserContacts;

@end