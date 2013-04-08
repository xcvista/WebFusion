//
//  decls.h
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#ifndef FusionKit_D_decls_h
#define FusionKit_D_decls_h

#import <Foundation/Foundation.h>
#import <FusionKit/FusionKit.h>
#import <FusionProtocol/FusionProtocol.h>
#import <readline/readline.h>
#import <readline/history.h>
#import <termios.h>

#define eprintf(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
#define osprintf(format, ...) [WFSTR(format, ##__VA_ARGS__) cStringUsingEncoding:[NSString defaultCStringEncoding]]
#define oprintf(format, ...) printf("%s", osprintf(format, ##__VA_ARGS__))
#define eoprintf(format, ...) eprintf("%s", osprintf(format, ##__VA_ARGS__))

ssize_t getpass2(char **lineptr, size_t *n, FILE *stream);

#endif
