//
//  WFTypes.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#ifndef FusionKit_D_WFTypes_h
#define FusionKit_D_WFTypes_h

#import <FusionKit/WFDecls.h>

WFBeginDecls

typedef uint64_t WFTimestamp;
WFExtern WFTimestamp WFTimestampFromTimeInterval(NSTimeInterval);
WFExtern NSTimeInterval WFTimeIntervalFromTimestamp(WFTimestamp);

WFExtern NSString *WFVersion(void);

WFEndDecls

#endif
