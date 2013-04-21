//
//  WFUserContact.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-14.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

WFBeginDecls

@class WFUniversalContact;

@interface WFUserContact : WFObject

@property WFUniversalContact *avatar;
@property id ID;
@property NSString *name;
@property NSArray *ucs;
@property id user;

WFEndProperties;

@end

WFEndDecls
