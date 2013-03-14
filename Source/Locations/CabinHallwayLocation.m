//
//  CabinHallwayLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "CabinHallwayLocation.h"

@implementation CabinHallwayLocation

+ (NSString*) arrive
{
    return @"You step through the doorway into the hallway.  It's a cosy little hallway with doors leading off it in four different directions.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"There are hardwood floors, and paintings on the wall of the little hallway. There's a door leading in each direction, one to the bedroom, one to the bathroom, one to the main room, and one that's locked that you can't get through.  You notice the floor is a bit dinged up in a few places.";
    }
    if ([subject isEqualToString:@"painting"] || [subject isEqualToString:@"paintings"])
    {
        return @"They're those paintings you always see in cabins or hunters houses.  Mostly of animals and stuff, not really anything especially interesting. Although you do notice something odd about one of the paintings, and when you shift it to the side you see someone's scribbled, \"The keys rest with three adventurers.\" in small print.";
    }
    if ([subject isEqualToString:@"floor"])
    {
        return @"There are various dinges and scratches everywhere, and a floorboard that appears to be loose.";
    }
    if ([subject isEqualToString:@"floorboard"])
    {
        return @"It almost looks like you could pry this floorboard up if you had a screwdriver or something.";
    }
    return [super look:subject];
    if ([subject isEqualToString:@"locked door"])
    {
        return @"It's an ornate looking door with three strange keyholes.  You must have to find the keys somewhere.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"bedroom"])
    {
        return [Player setCurrentLocation:@"CabinBedroomLocation"];
    }
    if ([subject isEqualToString:@"bathroom"])
    {
        return [Player setCurrentLocation:@"CabinBathroomLocation"];
    }
    if ([subject isEqualToString:@"main room"])
    {
        return [Player setCurrentLocation:@"CabinLocation"];
    }
    if ([subject isEqualToString:@"locked door"] || [subject isEqualToString:@"locked room"])
    {
        return @"The door is locked and you can't get through.";
    }
    return [super go:subject];
}

+ (NSString*) use:(NSString *)subject
{
    if(![Player hasItem:subject]) return [super use:subject];
    if ([subject isEqualToString:@"screwdriver"])
    {
        if ([Player hasItem:@"murder book"] || [(NSNumber*)[Player attributeValue:@"murderBookInPool"] boolValue])
            return @"You already opened it up and collected what was to be had.";
        else
        {
            [Player giveItem:@"murder book"];
            return @"You use the screwdriver to pry up the floorboard, and looking inside you find a little book filled with crossed off names, as if these targets have been eliminated.  You pull it out and tap the floorboard back down into place.";
        }
    }
    if ([subject isEqualToString:@"goblin key"])
    {
        return @"There isn't much you can do with this other than unlock the door.";
    }
    if ([subject isEqualToString:@"chasm key"])
    {
        return @"There isn't much you can do with this other than unlock the door.";
    }
    if ([subject isEqualToString:@"chest key"])
    {
        return @"There isn't much you can do with this other than unlock the door.";
    }
    return [super use:subject];
}

+ (NSString*) whistle
{
    return @"Cats run in through the open bathroom door and scratch at a loose floorboard.  You don't understand where all these cats keep coming from, and what's more confusing is where they're going to...";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    if ([verb isEqualToString:@"unlock"] && [subject isEqualToString:@"door"])
    {
        if ([Player hasItem:@"goblin key"] && [Player hasItem:@"chasm key"] && [Player hasItem:@"chest key"])
            return @"You unlock the door and step through. Looking around you realize that you're in Nathan's basement and the door has disappeared behind you. Going upstairs you find Nathan typing away at his computer and you- Wait, you're standing right behind me aren't you?  Uh, wow, were you trapped in my spatial anomaly this whole time? That's really odd. I can't imagine how you got in there. <.< >.>\nAnyway, would you like a ride home?\n\nYou win! Now open that dan present.";
        else return @"You don't have all of the keys necessary to unlock the door.";
    }
    return [super wildcardWithVerb:verb subject:subject];
}

@end
