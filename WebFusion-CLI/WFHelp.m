//
//  WFHelp.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFHelp.h"
#import "decls.h"

@implementation WFHelp

+ (void)load
{
    WFRegisterSubject(@"help", [[self alloc] init]);
}

- (void)_default:(NSArray *)args
{
    if ([args count] > 2)
    {
        NSString *name = [args[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        id target = subjects[name];
        if ([target respondsToSelector:@selector(help:)])
            [target help:@[name, @"help"]];
        else
            eoprintf(@"\aERROR: Cannot find help for subject %@.\n", name);
    }
    else
    {
        [self help:args];
    }
}

- (void)help:(NSArray *)args
{
    eoprintf(@"WebFusion CLI, version 4.0 (git version %@)\n", WFVersion());
    eoprintf(@"Copyright 2013, myWorld Creations, all rights reserved.\n\n");
    eoprintf(@"Type \"<subject-name> help\" to acquire help on a certain subject.\n");
    eoprintf(@"Type \"help subjects\" to acquire a list of subjects.\n");
}

- (void)subjects:(NSArray *)args
{
    eoprintf(@"The following is a list of avalible subjects:\n");
    for (NSString *name in subjects)
        eoprintf(@"> %@\n", name);
    eprintf("\n");
}

- (void)version:(NSArray *)args
{
    eoprintf(@"WebFusion CLI, version 4.0 (git version %@)\n", WFVersion());
    eoprintf(@"Copyright 2013, myWorld Creations, all rights reserved.\n\n");
}

@end
