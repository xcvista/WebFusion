//
//  WFNewsRequest.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-9.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/FusionKit.h>
#import <FusionProtocol/NSDate+WFTimestamp.h>

WFBeginDecls

WFStaticString(WFNewsTypeNone, nil);

@interface WFNewsRequest : WFObject

@property NSUInteger count;
@property WFTimestamp lastT;
@property NSString *type;

WFEndProperties;

+ (NSArray *)newsBeforeEpoch:(NSDate *)epoch
                       count:(NSUInteger)count
                        type:(NSString *)type
                       error:(NSError **)error;

@end

@interface WFNewsRequest (WFRemoteMethods)

- (NSArray *)getWhatzNew;

@end

WFEndDecls
