//
//  WFConnection.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import <FusionKit/WFObject.h>

WFBeginDecls

#define WFSendMethodWithType(type) [super sendMethod:_cmd returnClass:[type class]];

@interface WFObject (WFSending)

- (Class)classForMethod:(SEL)method;

@end

@interface WFConnection : NSObject

@property NSURL *serverRoot;

+ (WFConnection *)connection;

- (NSData *)dataWithData:(NSData *)data
              fromMethod:(NSString *)method
                   error:(NSError *__autoreleasing *)error;

- (NSString *)userAgent;

@end

WFEndDecls
