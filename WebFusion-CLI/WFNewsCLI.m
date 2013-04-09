//
//  WFNewsCLI.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFNewsCLI.h"
#import <FusionProtocol/FusionProtocol.h>
#import "decls.h"

@implementation WFNewsCLI

+ (void)load
{
    WFRegisterSubject(@"news", [[self alloc] init]);
}

- (id)init
{
    if (self = [super init])
    {
        self.news = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (void)reload:(NSArray *)args
{
    NSUInteger count = 0;
    if ([args count] > 2)
    {
        // Not now.
    }
    
    if (!count)
        count = 5;
    
    NSError *err = nil;
    NSArray *news = [WFNewsRequest newsBeforeEpoch:[NSDate distantFuture]
                                             count:count
                                              type:WFNewsTypeNone
                                             error:&err];
    
    if (!news)
    {
        eoprintf(@"ERROR: Cannot load news list: %@\n", [err localizedDescription]);
        return;
    }
    
    self.news = [NSMutableOrderedSet orderedSetWithArray:news];
    [self.news sortUsingComparator:^NSComparisonResult(WFNews *obj1, WFNews *obj2) {
        if (obj1.publishTime > obj2.publishTime)
            return NSOrderedAscending;
        else if (obj1.publishTime == obj2.publishTime)
            return NSOrderedSame;
        else
            return NSOrderedDescending;
    }];
    
    if ([args[1] isEqual:@"reload"])
        printf("Reloaded %ld news items.\n", [self.news count]);
}

- (void)list:(NSArray *)args
{
    if (![self.news count])
        [self reload:args];
    
    for (WFNews *news in self.news)
    {
        oprintf(@"ID:      %@\n"
                 "From:    %@ (%@)\n"
                 "Subject: %@\n"
                 "Time:    %@ ago\n",
                news.ID, [news.authorUC displayName], news.svr, news.title, [[NSDate dateFromTimestamp:news.publishTime] displayTime]);
        if ([news.content length])
            oprintf(@"\n%@\n", news.content);
        printf("\n  === EOM ===\n\n");
    }
}

@end
