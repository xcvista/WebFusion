//
//  WFUniversalContact.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

WFBeginDecls

@interface WFUniversalContact : WFObject

@property NSString *dispName;
@property NSString *scrName;
@property NSString *avatar;
@property NSString *svr;
@property id svrId;
@property id ID;

WFEndProperties;

- (NSString *)displayName;
- (NSURL *)avatarURL;

@end

WFEndDecls
