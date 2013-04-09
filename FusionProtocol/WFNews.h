//
//  WFNews.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>
#import <FusionProtocol/NSDate+WFTimestamp.h>

WFBeginDecls

@class WFUniversalContact;

@interface WFNews : WFObject

@property NSString *href;
@property NSString *title;
@property NSString *content;
@property WFUniversalContact *authorUC;
@property NSArray *medias;
@property WFTimestamp publishTime;
@property id ID;
@property id svr;
@property NSString *type;
@property WFNews *refer;

#if defined(GNUSTEP)
@property id _end;
#endif

@end

WFEndDecls
