//
//  CabinLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "CabinLocation.h"

@implementation CabinLocation

+ (NSString*) arrive
{
    return @"You come into a reasonably sized main room, although it is a little small. It has a fireplace, dining table, kitchen, and couches. The decor seems very cabiny. You know what I mean, like a cabin. It's difficult to describe okay! Don't judge me!";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"It's clearly a hunters cabin. It's kinda cozy, with the front door on the south wall, the kitchen area on the east and a table to eat at on the west.  There's a big fireplace on the north wall. There are several couches pulled around the fireplace to form a sitting area. A door opens onto a hallway in the northwest corner of the room between the couches and the dining area. You can see windows on the south wall next to the front door and on the east wall opposite of the hallway.";
    }
    if ([subject isEqualToString:@"kitchen"] || [subject isEqualToString:@"kitchen area"])
    {
        return @"It's a rather basic kitchen, with an oven and stove, drawers, and cupboards. There seems to be electricity, so maybe there's a generator powering the house or something. The fridge is a bit small, and tucked in the corner of the room. It has a kinda woodsy feel to it, not modern looking in any way.";
    }
    if ([subject isEqualToString:@"stove"] || [subject isEqualToString:@"oven"])
    {
        return @"It's a just a regular oven with a stove top.";
    }
    if ([subject isEqualToString:@"fridge"])
    {
        return @"There's nothing out of the ordinary about this fridge.";
    }
    if ([subject isEqualToString:@"window"] || [subject isEqualToString:@"windows"])
    {
        return @"Looking out the windows you see some sort of body of water outside.";
    }
    if ([subject isEqualToString:@"table"] || [subject isEqualToString:@"dining table"])
    {
        return @"It's a simple wooden table with four chairs pulled up around it. There's a simple table cloth on the table, with some candles and a basket of pine cones for decor.";
    }
    if ([subject isEqualToString:@"fireplace"])
    {
        return @"There's a moosehead mounted over a large ornate fireplace with pictures of a hunter on top.  A fire roars in the fireplace, lighting the cabin and-Wait, didn't you just slide out of there?  How is there a fire...";
    }
    if ([subject isEqualToString:@"cupboards"] || [subject isEqualToString:@"cupboard"])
    {
        return @"You open the cupboards and find that they're full of empty bottles and various china for eating.";
    }
    if ([subject isEqualToString:@"china"])
    {
        return @"No, you're in a cabin, not Asia. How would you even look at China?  Be in space?";
    }
    if ([subject isEqualToString:@"moose head"])
    {
        return @"It's what appears to be the decapitated head of a moose, were you expecting something different?";
    }
    if ([subject isEqualToString:@"pictures"] || [subject isEqualToString:@"picture"])
    {
        return @"Looking at the couches you can see that-You wanted to look at the pictures?  Too bad, I'm showing you the couches!";
    }
    if ([subject isEqualToString:@"couches"] || [subject isEqualToString:@"couch"])
    {
        return @"Looking at the couches you can see that they use animal pelts for their throws, but actually look very comfortable.";
    }
    if ([subject isEqualToString:@"drawer"] || [subject isEqualToString:@"drawers"])
    {
        if ([Player hasItem:@"screwdriver"] || [Player hasItem:@"screw"])
            return @"Pulling open one of the drawers in the kitchen you find it empty.";
        else
            return @"Pulling open one of the drawers in the kitchen you find a single screw with \"Crusty Man Jenkins Water Activated Screw\" etched in the side.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"hallway"])
    {
        return [Player setCurrentLocation:@"CabinHallwayLocation"];
    }
    if ([subject isEqualToString:@"front door"] || [subject isEqualToString:@"outside"])
    {
        return [Player setCurrentLocation:@"PoolLocation"];
    }
    return [super go:subject];
}


+ (NSString*) get:(NSString *)subject
{
    BOOL isPineConeCollected = [(NSNumber*)[Player attributeValue:@"pineConeCollected"] boolValue];
    
    if(![Player hasItem:subject])
    {
        if ([subject isEqualToString:@"screw"] && ![Player hasItem:@"screwdriver"])
        {
            [Player giveItem:@"screw"];
            return @"You pull open the kitchen drawer and take the screw labeled \"Crusty Man Jenkins Water Activated Screw\" out.";
        }
        if ([subject isEqualToString:@"pine cone"] && isPineConeCollected == FALSE)
        {
            [Player giveItem:@"pine cone"];
            [Player setAttribute:@"pineConeCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You walk over to the table and take one of the pine cones out of the basket.";
        }
        if (([subject isEqualToString:@"bottle"] || [subject isEqualToString:@"empty bottle"]) && ![Player hasItem:@"bottle"] && ![Player hasItem:@"water"])
        {
            [Player giveItem:@"bottle"];
            return @"You pull open the kitchen cupboard and take a bottle out.";
        }
    }
    else if ([subject isEqualToString:@"china"])
    {
        return @"Stop trying to pick up entire countries that aren't even nearby!";
    }
    else return @"You don't need to get the same thing more than once.";
    
    return [super get:subject];
}

+ (NSString*) use:(NSString *)subject
{
    if(![Player hasItem:subject]) return [super use:subject];
    return [super use:subject];
}

+ (NSString*) talk:(NSString*) subject
{
    return [super talk:subject];
}

+ (NSString*) whistle
{
    return @"Upon blowing your whistle a cat pops out from under the sink, jump up on the kitchen counter and paws at the drawer and the cupboard doors.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
