//
//  WFNewsRequest.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFNewsRequest.h"
#import "WFNews.h"

WFStaticStringValue(WFNewsTypeNone, nil);

@implementation WFNewsRequest

- (Class)classForMethodGetWhatzNew
{
    return [WFNews class];
}

+ (NSArray *)newsBeforeEpoch:(NSDate *)epoch
                       count:(NSUInteger)count
                        type:(NSString *)type
                       error:(NSError *__autoreleasing *)error
{
    WFNewsRequest *request = [[WFNewsRequest alloc] init];
    request.count = count;
    request.lastT = [epoch timestamp];
    request.type = type;
    
    id returnValue = [request getWhatzNew];
    if ([returnValue isKindOfClass:[NSArray class]])
    {
        return returnValue;
    }
    else
    {
        WFAssignPointer(error, returnValue);
        return nil;
    }
}

@end
