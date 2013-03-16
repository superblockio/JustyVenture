//
//  Mobile.m
//  JustyVenture
//
//  Created by Chad Ian Anderson on 03/15/13.
//  Copyright 2013 Nathan Swenson. All rights reserved.
//

#import "Mobile.h"

@implementation Mobile

static NSMutableArray* _inventory;
static NSMutableDictionary* _attributes;

// Initializes the inventory and attributes when the class is first loaded
+ (void)initialize
{
    _inventory = [[NSMutableArray alloc] init];
    _attributes = [[NSMutableDictionary alloc] init];
}

// Methods for manipulating the inventory
+ (void) giveItem:(NSString*)item
{
    if(![_inventory containsObject:item])[_inventory addObject:item];
}

+ (void) removeItem:(NSString*) item
{
    [_inventory removeObject:item];
}

+ (BOOL) hasItem:(NSString*) item
{
    return [_inventory containsObject:item];
}

+ (NSArray*) items
{
    return [NSArray arrayWithArray:_inventory];
}

+ (void) setAttribute:(NSString*)attribute toValue:(NSObject*)value
{
    [_attributes setValue:value forKey:attribute];
}

+ (NSObject*) attributeValue:(NSString *) attribute
{
    return [_attributes valueForKey:attribute];
}

@end
