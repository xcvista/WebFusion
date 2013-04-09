//
//  WFSystem.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFSystem.h"
#import "decls.h"
#import <FusionKit/FusionKit.h>

@implementation WFSystem

- (void)_default:(NSArray *)args
{
    [self help:args];
}

- (void)help:(NSArray *)args
{
    eoprintf(@"Here is a list of system methods:\n");
    eoprintf(@"> exit       - Exit from WebFusion.\n");
    eoprintf(@"> getuid     - Print the current user ID.\n");
    eoprintf(@"> getserver  - Print the current server root.\n");
    eoprintf(@"\n");
}

- (void)exit:(NSArray *)args
{
    eoprintf(@"Bye.\n");
    exit(0);
}

- (void)getuid:(NSArray *)args
{
    oprintf(@"%@\n", username);
}

- (void)getserver:(NSArray *)args
{
    oprintf(@"%@\n", [[WFConnection connection].serverRoot absoluteString]);
}

@end
