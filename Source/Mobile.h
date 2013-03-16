//
//  Mobile.h
//  JustyVenture
//
//  Created by Chad Ian Anderson on 03/15/13.
//  Copyright 2013 Nathan Swenson. All rights reserved.
//

#import <Foundation/Foundation.h>

// A static class to represent mobiles, including their
// inventory, room, and attributes pertaining to the game.
@interface Mobile : NSObject

+ (void)initialize;


// Inventory stuff

// Gives the mobile an item with the given name, if they don't already have it.
+ (void) giveItem:(NSString*)item;

// Removes the item from the mobile's inventory if they have one.
+ (void) removeItem:(NSString*) item;

// Checks to see if they have an item of the given name
+ (BOOL) hasItem:(NSString*) item;

// Get ALL the items!
+ (NSArray*) items;


// Attribute stuff
+ (void) setAttribute:(NSString*)attribute toValue:(NSObject*)value;
+ (NSObject*) attributeValue:(NSString*)attribute;

@end
