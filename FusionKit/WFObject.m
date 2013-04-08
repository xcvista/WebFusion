//
//  WFObject.m
//  FusionKit.D
//
//  Created by Maxthon Chan on 13-4-8.
//  Copyright (c) 2013年 myWorld Creations. All rights reserved.
//

#import "WFObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation WFObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        // Get a list of properties.
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        if (properties)
        {
            // Enumerate all properties.
            
            for (unsigned int i = 0; i < propertyCount; i++)
            {
                objc_property_t property = properties[i];
                NSString *name = @(property_getName(property)); // Property name.
                NSString *attr = @(property_getAttributes(property)); // Property attributes
                NSString *type = @"@";
                BOOL readonly = NO;
                WFLog(@"Accessing property %@ with attributes %@", name, attr);
                
                // Check the property type.
                NSArray *attrs = [attr componentsSeparatedByString:@","];
                for (NSString *attribute in attrs)
                {
                    if ([attribute hasPrefix:@"T"])
                    {
                        type = [attribute substringFromIndex:1];
                    }
                    else if ([attribute hasPrefix:@"R"])
                    {
                        readonly = YES;
                    }
                }
                
                id value = dictionary[name]; // Find the value.
                
                if (!value && [name isEqualToString:@"ID"])
                {
                    value = dictionary[@"id"]; // ID is used instead of id.
                }
                
                if (!value)
                    NSLog(@"WARNING: Cannot determine value for property %@, nil is used.", name);
                
                if (!readonly && value)
                {
                    // Dispatching would require some tricks.
                    if ([type hasPrefix:WFType(id)]) // Objects. Special requirements is required.
                    {
                        Class class = Nil;
                        id object = value;
                        if ([type length] > 3)
                        {
                            NSString *className = [type substringWithRange:NSMakeRange(2, [type length] - 3)];
                            WFLog(@"Class type %@ occurred for property %@.", className, name);
                            class = NSClassFromString(className);
                            if (!class)
                                NSLog(@"WARNING: Class type %@ asked for my broperty %@ not found.", className, name);
                        }
                        
                        if (!class)
                        {
                            class = [self classForProperty:name];
                        }
                        
                        if (!class)
                            NSLog(@"WARNING: Class for property %@ cannot be determined.", name);
                        
                        if (class && [class isSubclassOfClass:[WFObject class]])
                        {
                            if ([value isKindOfClass:[NSDictionary class]])
                                object = [[class alloc] initWithDictionary:value];
                            else if ([value isKindOfClass:[NSArray class]])
                            {
                                NSArray *array = value;
                                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
                                for (id item in array)
                                {
                                    if ([item isKindOfClass:[NSDictionary class]])
                                    {
                                        [mutableArray addObject:[[class alloc] initWithDictionary:item]];
                                    }
                                    else
                                    {
                                        NSLog(@"WARNING: Object typed %@ occured in array asking for objects typed %@.", NSStringFromClass([item class]), NSStringFromClass(class));
                                        [mutableArray addObject:item];
                                    }
                                }
                                object = [mutableArray copy];
                            }
                        }
                        [self setValue:object forKey:name];
                    }
                    else
                    {
                        // Everything else.
                        [self setValue:value forKey:name];
                    }
                }
            }
            free(properties);
            properties = NULL;
        }
    }
    return self;
}

- (Class)classForProperty:(NSString *)property
{
    return Nil;
}

- (NSDictionary *)dictionaryRepresentation
{
    
}

@end
