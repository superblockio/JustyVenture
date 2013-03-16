//
//  Player.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright 2011 Nathan Swenson. All rights reserved.
//

#import "Player.h"

@implementation Player

static NSString* _currentRoom;
static NSImage* _image;
static NSString* _prompt;

// Initializes the inventory when the class is first loaded
+ (void)initialize
{
    _inventory = [[NSMutableArray alloc] init];
    _attributes = [[NSMutableDictionary alloc] init];
    _prompt = nil;
}

+ (NSString*) currentRoom
{
    return _currentRoom;
}

// Note: this method sets which room the player is in and returns the string from
// that room's "arrive" method. In most cases, the string returned by
// this method should be directly returned to the user as the output.
+ (NSString*) setCurrentRoom:(NSString*)room
{
    [_currentRoom release];
    _currentRoom = [room retain];
    Class roomClass = NSClassFromString(_currentRoom);
    if(roomClass == nil)
    {
        _currentRoom = [@"Room" retain];
        roomClass = NSClassFromString(_currentRoom);
        return [NSString stringWithFormat:@"Error: No class with name %@ could be loaded.", room];
    }
    return [roomClass performSelector:@selector(arrive)];
}

+ (NSImage*) currentImage
{
    return _image;
}

+ (void) setCurrentImage:(NSImage*)image
{
    [_image release];
    _image = [image retain];
}

+ (NSString*) promptOverride
{
    return _prompt;
}

+ (void) overridePrompt:(NSString*)prompt
{
    [_prompt release];
    _prompt = [prompt retain];
}

// Starts the game over from the beginning, clearing inventory and attributes
+ (NSString*) softReset
{
    [_inventory autorelease];
    _inventory = [[NSMutableArray alloc] init];
    [_attributes autorelease];
    _attributes = [[NSMutableDictionary alloc] init];
    return [Player setCurrentRoom:@"SampleRoom"];
}

@end
