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
    if ([subject isEqualToString:@"kitchen"])
    {
        return @"It's a rather basic kitchen, with an oven and stove, drawers, and cupboards. There seems to be electricity, so maybe there's a generator powering the house or something. The fridge is a bit small, and tucked in the corner of the room. It has a kinda woodsy feel to it, not modern looking in any way.";
    }
    if ([subject isEqualToString:@"table"])
    {
        return @"It's a simple wooden table with four chairs pulled up around it. There's a simple table cloth on the table, with some candles and a basket of pine cones for decor.";
    }
    if ([subject isEqualToString:@"fireplace"])
    {
        return @"There's a moosehead mounted over a large ornate fireplace with pictures of a hunter on top.  A fire roars in the fireplace, lighting the cabin and-Wait, didn't you just slide out of there?  How is there a fire...";
    }
    if ([subject isEqualToString:@"cupboards"])
    {
        return @"You open the cupboards and find that they're full of empty bottles and various china for eating.";
    }
    if ([subject isEqualToString:@"couches"])
    {
        return @"Looking at the couches you can see that they use animal pelts for their throws, but actually look very comfortable.";
    }
    if ([subject isEqualToString:@"drawer"])
    {
        if ([Player hasItem:@"screwdriver"])
            return @"Pulling open one of the drawers in the kitchen you find a matchbox.";
        else if ([Player hasItem:@"matchbox"])
            return @"Pulling open one of the drawers in the kitchen you find a screwdriver.";
        else if ([Player hasItem:@"screwdriver"] && [Player hasItem:@"matchbox"])
            return @"Pulling open one of the drawers in the kitchen you find it empty.";
        else
            return @"Pulling open one of the drawers in the kitchen you find a matchbox and a screwdriver.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"hallway"])
    {
        return [Player setCurrentLocation:@"CabinHallwayLocation"];
    }
    if ([subject isEqualToString:@"outside"])
    {
        return [Player setCurrentLocation:@"PoolLocation"];
    }
    return [super get:subject];
}


+ (NSString*) get:(NSString *)subject
{
    if ([subject isEqualToString:@"matchbox"])
    {
        [Player giveItem:@"matchbox"];
        return @"You pull open the kitchen drawer and take the matchbox out.";
    }
    if ([subject isEqualToString:@"screwdriver"])
    {
        [Player giveItem:@"screwdriver"];
        return @"You pull open the kitchen drawer and take the screwdriver out.";
    }
    if ([subject isEqualToString:@"bottle"])
    {
        [Player giveItem:@"bottle"];
        return @"You pull open the kitchen cupboard and take a bottle out.";
    }
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
