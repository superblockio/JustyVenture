//
//  Player.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright (c) 2011 University of Utah. All rights reserved.
//

#import "Player.h"
#import "Achievement.h"

@interface Player()

+ (void) loadAchievements;

@end

@implementation Player

static NSMutableArray* _inventory;
static NSString* _currentLocation;
static NSString* _saneLocation;
static NSImage* _image;
static NSMutableDictionary* _attributes;
static NSString* _prompt;
static NSMutableDictionary* _achievements;
static NSObject<PlayerDelegate>* _delegate;

// Initializes the inventory when the class is first loaded
+ (void)initialize
{
    _inventory = [[NSMutableArray alloc] init];
    _attributes = [[NSMutableDictionary alloc] init];
    _achievements = [[NSMutableDictionary alloc] init];
    [Player loadAchievements];
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

+ (NSString*) saneLocation
{
    return _saneLocation;
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

+ (NSString*) setSaneLocation:(NSString*)location
{
    _saneLocation = _currentLocation;
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

+ (void) achievementGet:(NSString*)name
{
    Achievement* achievement = [_achievements valueForKey:name];
    if(achievement == nil) return;
    if(![achievement achieved])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:name];
        [achievement setAchieved:YES];
        NSLog(@"Achievement get: %@",name);
        [Player overridePrompt:[NSString stringWithFormat:@"Achievement get: %@",name]];
        NSLog(@"%@",[Player promptOverride]);
    }
}

+ (NSString*) hintAchievement:(NSString *)name
{
    Achievement* achievement = [_achievements valueForKey:name];
    if(achievement != nil)return [achievement hint];
    else return @"Error: not a valid achievement name";
}

+ (NSString*) showAchievements
{
    NSArray* achievements = [_achievements allValues];
    NSString* concatString = @"Achievements:\n\n";
    for (int i = 0; i < [achievements count]; i++) 
    {
        Achievement* currentAchievement = [achievements objectAtIndex:i];
        if([currentAchievement achieved]) concatString = [concatString stringByAppendingFormat:@"%@ -- Achieved\n\n", [currentAchievement name]];
        else concatString = [concatString stringByAppendingFormat:@"%@ -- Not achieved\n\n", [currentAchievement name]];
    }
    return concatString;
}

+ (void) loadAchievements
{
    Achievement* maneSix = [[Achievement alloc] init];
    [maneSix setName:@"the mane six"];
    [maneSix setDescription:@"Talk to Rainbow Dash, Twilight Sparkle, Pinkie Pie, Applejack, Fluttershy, and Rarity within the same adventure."];
    [maneSix setHint:@"Talking is magic!"];
    [maneSix setAchieved:[[NSUserDefaults standardUserDefaults] boolForKey:[maneSix name]]];
    
    Achievement* chaos = [[Achievement alloc] init];
    [chaos setName:@"chaos is a wonderful thing"];
    [chaos setDescription:@"Complete the 'go insane' sidequest"];
    [chaos setHint:@"Don't suffer from insanity, enjoy every minute of it!"];
    [chaos setAchieved:[[NSUserDefaults standardUserDefaults] boolForKey:[chaos name]]];
    
    Achievement* tank = [[Achievement alloc] init];
    [tank setName:@"like a tank"];
    [tank setDescription:@"Lose the game, complete the old man sidequest, then come back to life and win."];
    [tank setHint:@"Don't give up when you lose. When life gives you lemons, make life take the lemons back!"];
    [tank setAchieved:[[NSUserDefaults standardUserDefaults] boolForKey:[tank name]]];
    
    Achievement* chasm = [[Achievement alloc] init];
    [chasm setName:@"chasm master"];
    [chasm setDescription:@"Cross the chasm using all three methods."];
    [chasm setHint:@"There's three ways to cross the chasm. Can you find them all?"];
    [chasm setAchieved:[[NSUserDefaults standardUserDefaults] boolForKey:[chasm name]]];
    
    Achievement* cookieMonster = [[Achievement alloc] init];
    [cookieMonster setName:@"cookie monster"];
    [cookieMonster setDescription:@"Eat ALL the lava cookies!"];
    [cookieMonster setHint:@"Lava cookies are best cookies"];
    [cookieMonster setAchieved:[[NSUserDefaults standardUserDefaults] boolForKey:[cookieMonster name]]];
    
    Achievement* beach = [[Achievement alloc] init];
    [beach setName:@"steppin' on the beach"];
    [beach setDescription:@"Dance on the beach after returning to Golden Sands from the dungeon"];
    [beach setHint:@"The beach isn't initially ready for your mad steppin' skills. You'll have to come back later."];
    [beach setAchieved:[[NSUserDefaults standardUserDefaults] boolForKey:[beach name]]];
    
    [_achievements setValue:maneSix forKey:[maneSix name]];
    [_achievements setValue:chaos forKey:[chaos name]];
    [_achievements setValue:tank forKey:[tank name]];
    [_achievements setValue:chasm forKey:[chasm name]];
    [_achievements setValue:cookieMonster forKey:[cookieMonster name]];
    [_achievements setValue:beach forKey:[beach name]];
}

// Does the game as soft reset but also clears out achievements, returning the
// game to its factory state so to speak.
+ (NSString*) hardReset
{
    NSArray* achievements = [_achievements allValues];
    for (int i = 0; i < [achievements count]; i++) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[[achievements objectAtIndex:i] name]];
        [[achievements objectAtIndex:i] setAchieved:NO];
    }
    return [Player softReset];
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
