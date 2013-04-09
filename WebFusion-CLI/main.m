//
//  main.m
//  WebFusion-CLI
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "decls.h"
#import "WFHelp.h"
#import "WFSystem.h"
#import <objc/runtime.h>
#import <objc/message.h>

int main(int argc, const char * argv[])
{

    if (!getuid())
        eprintf("WARNING: Please do not run WebFusion as root user.\n");
    
    @autoreleasepool {
        
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSArray *args = [processInfo arguments];
        username = NSUserName();
        NSString *password = nil;
        serverRoot = nil;
        
        // Process command-line arguments to extract username and password.
        for (NSUInteger i = 1; i < [args count]; i++)
        {
            NSString *arg = args[i];
            
            if ([arg hasPrefix:@"-"]) // Switches.
            {
                NSUInteger option = NSNotFound;
                NSArray *options = @[@"-l", @"-p", @"-s"];
                if ((option = [options indexOfObject:arg]) != NSNotFound)
                {
                    if (++i < [args count])
                    {
                        NSString *value = args[i];
                        switch (option)
                        {
                            case 0:
                                username = value;
                                break;
                            case 1:
                                password = value;
                                break;
                            case 2:
                                serverRoot = [NSURL URLWithString:value];
                                if (!serverRoot)
                                    eoprintf(@"WARNING: Server address \"%@\" invalid. Default is used.\n", value);
                                break;
                            default:
                                eoprintf(@"ERROR: Unrecognized switch: %@\n", arg);
                                exit(-1);
                                break;
                        }
                    }
                    else
                    {
                        eoprintf(@"ERROR: Too few arguments after %@.\n", arg);
                        exit(-1);
                    }
                }
            }
            else
            {
                eoprintf(@"ERROR: Unrecognized argument: %@\n", arg);
            }
        }
        
        WFConnection *connection = [WFConnection connection];
        if (serverRoot)
            connection.serverRoot = serverRoot;
        
        eoprintf(@"Connectiong to server at %@...\n", [connection.serverRoot absoluteString]);
        
        // In case we do not have a password, get it from the console.
        if (!password)
        {
            char *buf = NULL;
            size_t size = 0;
            
            NSURL *root = [connection serverRoot];
            
            eoprintf(@"Password for %@://%@@%@%@: ", [root scheme], username, [root host], [root path]);
            if (getpass2(&buf, &size, stdin) < 0)
            {
                eoprintf(@"ERROR: Cannot read password.\n");
                exit(-1);
            }
            password = [[NSString stringWithCString:buf
                                           encoding:[NSString defaultCStringEncoding]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            free(buf);
        }
        
        NSError *err = nil;
        
        if (![WFLogin loginAsUser:username
                     withPassword:password
                            error:&err])
        {
            if (err)
            {
                eoprintf(@"ERROR: Login failed: %@", [err localizedDescription]);
                exit(1);
            }
            else
            {
                eoprintf(@"ERROR: Login failed: Bad password.");
                exit(1);
            }
        }
        err = nil;
        
        eoprintf(@"\n\nDear %@, welcome to %@.\n", username, [connection.serverRoot absoluteString]);
        eoprintf(@"To get help for this command line, issue \"help\".\n\n");
        
        subjects = @{
                     @"help": [[WFHelp alloc] init],
                     @"system": [[WFSystem alloc] init]
                     };
        
        NSString *prompt = (getuid()) ? @"WebFusion$ " : @"WebFusion# ";
        NSString *prompt2 = @"         > ";
        
        BOOL catchUp = NO;
        unichar quote = 0;
        NSMutableArray *arguments = nil;
        NSMutableString *buf = nil;
        
        while (1)
        {
            // Get the command line.
            char *buffer = readline(osprintf(@"%@", (catchUp || quote) ? prompt2 : prompt));
            NSString *line = [[NSString stringWithCString:buffer encoding:[NSString defaultCStringEncoding]] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            add_history(buffer);
            free(buffer);
            
            if (!(catchUp || quote))
            {
                arguments = [NSMutableArray array];
                buf = [NSMutableString string];
            }
            else if (quote)
            {
                [buf appendString:@"\n"];
            }
                
            catchUp = NO;
            
            for (NSUInteger i = 0; i < [line length]; i++)
            {
                unichar ch = [line characterAtIndex:i];
                
                switch (ch)
                {
                    case '\'':
                    case '\"': // Quotes
                    {
                        if (!quote)
                        {
                            quote = ch;
                            break;
                        }
                        else if (quote == ch)
                        {
                            quote = 0;
                            break;
                        }
                    }
                    default:
                    {
                        if (quote)
                        {
                            [buf appendFormat:@"%C", ch];
                        }
                        else
                        {
                            switch (ch)
                            {
                                case '\\': // Escapes
                                {
                                    if (++i < [line length])
                                    {
                                        ch = [line characterAtIndex:i];
                                        
                                        switch (ch)
                                        {
                                            case 'n':
                                                ch = '\n';
                                                break;
                                            case 't':
                                                ch = '\t';
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                    else
                                    {
                                        catchUp = YES;
                                        break;
                                    }
                                }
                                case ' ':
                                case '\t':
                                {
                                    // Word breaks.
                                    if ([buf length])
                                    {
                                        [arguments addObject:[buf copy]];
                                        buf = [NSMutableString string];
                                    }
                                    break;
                                }
                                default:
                                    [buf appendFormat:@"%C", ch];
                                    break;
                            }
                        }
                        break;
                    }
                }
            }
            
            if ([buf length] && !(quote || catchUp))
            {
                [arguments addObject:[buf copy]];
            }
            
            if (catchUp || quote)
                continue;
            
            if ([arguments count] == 0)
                continue;
            else if ([arguments count] == 1)
            {
                NSString *command = [arguments[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                id namedSubject = subjects[command];
                SEL selector = @selector(_default:);
                if ([namedSubject respondsToSelector:selector])
                    objc_msgSend(namedSubject, selector, @[command, @"_default"]);
                else
                {
                    id systemObject = subjects[@"system"];
                    selector = NSSelectorFromString(WFSTR(@"%@:", command));
                    if ([systemObject respondsToSelector:selector])
                        objc_msgSend(systemObject, selector, @[@"system", command]);
                    else
                    {
                        eoprintf(@"\aERROR: Subject or system method not recognized: %@\n", command);
                    }
                }
            }
            else
            {
                NSString *subject = [arguments[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *method = [arguments[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                id namedSubject = subjects[subject];
                SEL selector = NSSelectorFromString(WFSTR(@"%@:", method));
                SEL defaultSelector = @selector(_default:);
                if ([namedSubject respondsToSelector:selector]) // Mark.
                    objc_msgSend(namedSubject, selector, arguments);
                else if ([namedSubject respondsToSelector:defaultSelector])
                {
                    // Gotta use default handler
                    NSMutableArray *args = [arguments mutableCopy];
                    [args insertObject:@"_default" atIndex:1];
                    objc_msgSend(namedSubject, defaultSelector, args);
                }
                else
                {
                    // Using system object.
                    id defaultSubject = subjects[@"system"];
                    selector = NSSelectorFromString(WFSTR(@"%@:", subject));
                    if ([defaultSubject respondsToSelector:selector])
                    {
                        NSMutableArray *args = [arguments mutableCopy];
                        [args insertObject:@"system" atIndex:0];
                        objc_msgSend(defaultSubject, selector, args);
                    }
                    else
                    {
                        // Nobody does this.
                        eoprintf(@"\aERROR: Subject or system method not recognized: %@ %@\n", subject, method);
                    }
                }
                
            }
        }
        
    }
    return 0;
}

NSDictionary *subjects;
NSString *username;
NSURL *serverRoot;

ssize_t getpass2(char **lineptr, size_t *n, FILE *stream)
{
    struct termios old, new;
    ssize_t nread;
    
    /* Turn echoing off and fail if we can't. */
    if (tcgetattr(fileno (stream), &old) != 0)
        return -1;
    new = old;
    new.c_lflag &= ~ECHO;
    if (tcsetattr(fileno(stream), TCSAFLUSH, &new) != 0)
        return -1;
    
    /* Read the password. */
    nread = getline(lineptr, n, stream);
    
    /* Restore terminal. */
    (void)tcsetattr(fileno(stream), TCSAFLUSH, &old);
    
    return nread;
}

