//
//  WFOnlineUser.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-21.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

@class WFUserContactConnection, WFUserContact;

@interface WFOnlineUser : WFObject

@property WFUserContactConnection *us;
@property WFUserContact *uc;

@end
