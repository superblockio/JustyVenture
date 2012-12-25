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
    return @"You reach the bottom of the slide and slide out of a fireplace into a cabin. You're in a big room with a kitchen and dining area and such all in one.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"It's clearly a hunters cabin. It's kinda cozy, with the front door on the south wall, the kitchen area on the east and a table to eat at on the west.  There's a big fireplace on the north wall. There are several couches pulled around the fireplace to form a sitting area. A door opens onto a hallway in the northwest corner of the room between the couches and the dining area. You can see windows on the south wall next to the front door and on the east wall opposite of the hallway.";
    }
    if ([subject isEqualToString:@"kitchen"])
    {
        return @"It's a rather basic kitchen, with an oven and stove and cupboards. There seems to be electricity, so maybe there's a generator powering the house or something. The fridge is a bit small, and tucked in the corner of the room. It has a kinda woodsy feel to it, not modern looking in any way.";
    }
    if ([subject isEqualToString:@"table"])
    {
        return @"It's a simple wooden table with four chairs pulled up around it. There's a simple table cloth on the table, with some candles and a basket of pine cones for decor.";
    }
    if ([subject isEqualToString:@"fireplace"])
    {
        return @"There's a moosehead mounted over a large ornate fireplace with pictures of a hunter on top.  A fire roars in the fireplace, lighting the cabing and=Wait, didn't you just slide out of there?  How is there a fire...";
    }
    if ([subject isEqualToString:@"cupboards"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"couches"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"drawer"])
    {
        return @"";
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
    return @"";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
