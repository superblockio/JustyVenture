//
//  Player.h
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright 2011 Nathan Swenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mobile.h"

// A static class to represent the player, including their inventory,
// room, attributes pertaining to the game (such as whether they've
// talked to a certain character or done a certain thing), the image to
// display along with the text, and resetting the game.
@interface Player : Mobile

+ (void)initialize;

// Room stuff

// Uses magic GPS to get our current room as a string (the name of the Room subclass we are at)
+ (NSString*) currentRoom;

// Sets our current Room subclass to be the class specified by the string. Will return an error string on failure.
+ (NSString*) setCurrentRoom:(NSString*)room;


// Image stuff
+ (NSImage*) currentImage;
+ (void) setCurrentImage:(NSImage*)image;


// Prompt stuff
+ (NSString*) promptOverride;
+ (void) overridePrompt:(NSString*)prompt;


// Resetting stuff

// Starts the game over from the beginning, clearing inventory and attributes,
// returning the intro string of the game
+ (NSString*) softReset;

@end
