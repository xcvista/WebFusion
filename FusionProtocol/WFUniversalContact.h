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
@property id svr;
@property id svrId;
@property id ID;

- (NSString *)displayName;

@end

WFEndDecls
