//
//  WFNewsRequest.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

WFBeginDecls

@interface WFNewsRequest : WFObject

@property NSUInteger count;
@property WFTimestamp lastT;
@property NSString *type;

- (NSArray *)getWhatzNew;

@end

WFEndDecls
