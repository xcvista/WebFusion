//
//  WFObject.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/WFDecls.h>

WFBeginDecls

@class WFObject;

#define WFFrameworkBundle() [NSBundle bundleForClass:[WFObject class]]

@interface WFObject : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)dictionaryRepresentation;
- (Class)classForProperty:(NSString *)property;

@end

@interface WFObject (WFObjectJSON)

- (id)initWithJSONData:(NSData *)data error:(NSError **)error;

- (BOOL)canRepresentInJSON;
- (NSData *)JSONDataWithError:(NSError **)error;

@end

WFEndDecls
