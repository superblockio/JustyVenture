//
//  Player.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright 2011 Nathan Swenson. All rights reserved.
//

#import "Player.h"

@implementation Player

static NSMutableArray* _inventory;
static NSString* _currentLocation;
static NSImage* _image;
static NSMutableDictionary* _attributes;
static NSString* _prompt;
static NSObject<PlayerDelegate>* _delegate;

// Initializes the inventory when the class is first loaded
+ (void)initialize
{
    _inventory = [[NSMutableArray alloc] init];
    _attributes = [[NSMutableDictionary alloc] init];
    _prompt = nil;
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

+ (NSString*) currentLocation
{
    return _currentLocation;
}

// Note: this method sets the player's location and returns the string from
// that location's "arrive" method. In most cases, the string returned by
// this method should be directly returned to the user as the output.
+ (NSString*) setCurrentLocation:(NSString*)location
{
    [_currentLocation release];
    _currentLocation = [location retain];
    Class locationClass = NSClassFromString(_currentLocation);
    if(locationClass == nil)
    {
        _currentLocation = [@"Location" retain];
        locationClass = NSClassFromString(_currentLocation);
        return [NSString stringWithFormat:@"Error: No class with name %@ is loaded", location];
    }
    return [locationClass performSelector:@selector(arrive)];
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

+ (void) forceInputUpdateWithString:(NSString*)input
{
    [self.delegate playerForcedInputUpdateWithString:input];
}

+ (void) overridePrompt:(NSString*)prompt
{
    [_prompt release];
    _prompt = [prompt retain];
}

+ (void) setAttribute:(NSString*)attribute toValue:(NSObject*)value
{
    [_attributes setValue:value forKey:attribute];
}

+ (NSObject*) attributeValue:(NSString *) attribute
{
    return [_attributes valueForKey:attribute];
}

// Starts the game over from the beginning, clearing inventory and attributes
+ (NSString*) softReset
{
    [_inventory autorelease];
    _inventory = [[NSMutableArray alloc] init];
    [_attributes autorelease];
    _attributes = [[NSMutableDictionary alloc] init];
    return [Player setCurrentLocation:@"IntroLocation"];
}

+ (NSObject<PlayerDelegate>*) delegate
{
    return _delegate;
}
+ (void) setDelegate:(NSObject<PlayerDelegate>*) delegate
{
    _delegate = delegate;
}

@end
