//
//  WFDecls.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#ifndef FusionKit_D_WFDecls_h
#define FusionKit_D_WFDecls_h

#ifndef __OBJC__
#error This library will build only with Objective-C.
#endif

#if !__has_feature(blocks)
#error This library require blocks to build.
#endif

#if !__has_feature(objc_arc)
#error This library require Objective-C ARC to build.
#endif

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
#define WFBeginDecls extern "C" {
#define WFEndDecls }
#define WFExtern extern "C"
#else
#define WFBeginDecls
#define WFEndDecls
#define WFExtern extern
#endif // defined(__cplusplus)

WFBeginDecls

#if defined(DEBUG)
#define WFLog(format, ...) NSLog(format, ##__VA_ARGS__)
#else
#define WFLog(format, ...)
#endif

#define WFStaticString(name, value) WFExtern NSString *const name
#define WFStaticStringValue(name, value) NSString *const name = value

#define WFSTR(format, ...) ([NSString stringWithFormat:format, ##__VA_ARGS__])
#define WFType(type) (@(@encode(type)))
#define WFThisBundle ([NSBundle bundleForClass:[self class]])
#define WFClassFromSelector(selector, dictionary) (NSClassFromString((dictionary)[NSStringFromSelector(selector)]))

#define WFAssignPointer(pointer, value) do { \
typeof(pointer) __ptr = pointer; \
if (__ptr) *__ptr = value; \
} while(0)

WFEndDecls

#endif // FusionKit_D_WFDecls_h
