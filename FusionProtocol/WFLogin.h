//
//  WFLogin.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>

WFBeginDecls

@class WFWrapper;

@interface WFLogin : WFObject

@property NSString *user;
@property NSString *pass;

WFEndProperties;

+ (BOOL)loginAsUser:(NSString *)username withPassword:(NSString *)password error:(NSError **)error;

- (WFWrapper *)login;

@end

WFEndDecls
