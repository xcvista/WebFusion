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

- (void)_default:(NSArray *)args
{
    [self help:args];
}

- (void)help:(NSArray *)args
{
    eoprintf(@"WebFusion CLI, version 4.0 (git version %@)\n", WFVersion());
    eoprintf(@"Copyright 2013, myWOrld Creations, all rights reserved.\n\n");
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
    eoprintf(@"Copyright 2013, myWOrld Creations, all rights reserved.\n\n");
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return YES;
    else
    {
        NSString *name = NSStringFromSelector(aSelector);
        name = [name substringToIndex:[name length] - 1];
        id target = subjects[name];
        SEL action = @selector(help:);
        return [target respondsToSelector:action];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return [super methodSignatureForSelector:aSelector];
    else
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *name = NSStringFromSelector([anInvocation selector]);
    name = [name substringToIndex:[name length] - 1];
    id target = subjects[name];
    SEL action = @selector(help:);
    [anInvocation setTarget:target];
    [anInvocation setSelector:action];
    if (target && [target respondsToSelector:action])
    {
        [anInvocation invoke];
    }
    else
    {
        eoprintf(@"ERROR: Cannot find help on subject %@.", name);
    }
}

@end
