//
//  main.m
//  WebFusion-CLI
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "decls.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSArray *args = [processInfo arguments];
        NSString *username = NSUserName();
        NSString *password = nil;
        NSURL *serverRoot = nil;
        
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
            
            eoprintf(@"Password for %@@%@: ", username, [connection.serverRoot absoluteString]);
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
        
        eoprintf(@"Dear %@, welcome to %@.\n", username, [connection.serverRoot absoluteString]);
        eoprintf(@"To get help for this command line, issue \"help\".\n\n");
        
        NSString *prompt = (getuid()) ? @"WebFusion$ " : @"WebFusion# ";
        
        while (1)
        {
            // Get the command line.
            
        }
        
    }
    return 0;
}

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

