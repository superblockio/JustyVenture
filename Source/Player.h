//
//  Player.h
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright 2011 Nathan Swenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerDelegate <NSObject>

- (void) playerForcedInputUpdateWithString:(NSString*)string;

@end

// A static class to represent the player, including their inventory,
// location, attributes pertaining to the game (such as whether they've
// talked to a certain character or done a certain thing), the image to
// display along with the text, and resetting the game.
@interface Player : NSObject

+ (NSObject<PlayerDelegate>*) delegate;
+ (void) setDelegate:(NSObject<PlayerDelegate>*) delegate;

+ (void)initialize;


// Inventory stuff

// Gives the player an item with the given name, if they don't already have it.
+ (void) giveItem:(NSString*)item;

// Removes the item from the player's inventory if they have one.
+ (void) removeItem:(NSString*) item;

// Checks to see if they have an item of the given name
+ (BOOL) hasItem:(NSString*) item;

// Get ALL the items!
+ (NSArray*) items;


// Location stuff

// Uses magic GPS to get our current location as a string (the name of the Location subclass we are at)
+ (NSString*) currentLocation;

// Sets our current Location subclass to be the class specified by the string. Will return an error string on failure.
+ (NSString*) setCurrentLocation:(NSString*)location;


// Image stuff
+ (NSImage*) currentImage;
+ (void) setCurrentImage:(NSImage*)image;

// Prompt stuff
+ (NSString*) promptOverride;
+ (void) overridePrompt:(NSString*)prompt;
+ (void) forceInputUpdateWithString:(NSString*)input;


// Attribute stuff
+ (void) setAttribute:(NSString*)attribute toValue:(NSObject*)value;
+ (NSObject*) attributeValue:(NSString*)attribute;


// Resetting stuff

// Starts the game over from the beginning, clearing inventory and attributes,
// returning the intro string of the game
+ (NSString*) softReset;

@end
