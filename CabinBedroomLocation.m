//
//  CabinBedroomLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "CabinBedroomLocation.h"

@implementation CabinBedroomLocation

+ (NSString*) arrive
{
    return @"You step through the door into the bedroom, which is a bit small, has a bed in one corner, a desk in another, and a closet in the third.  There are windows on the south and west sides.";
}

+ (NSString*) look:(NSString *)subject
{
    BOOL isGunCollected = [(NSNumber*)[Player attributeValue:@"gunCollected"] boolValue];
    BOOL isPillowCollected = [(NSNumber*)[Player attributeValue:@"pillowCollected"] boolValue];
    
    if (subject == nil)
    {
        return @"It's a cozy little bedroom, with a bear skin rug and such. There's the bed, the dresser with a vanity on it, with all it's drawers for clothing, a work desk with books and papers on it, and some windows along the south and west sides. Not much of note, but still cozy anyway.";
    }
    if ([subject isEqualToString:@"window"] || [subject isEqualToString:@"windows"])
    {
        return @"Looking out the windows you see some sort of body of water outside.";
    }
    if ([subject isEqualToString:@"drawer"] || [subject isEqualToString:@"drawers"])
    {
        if ([Player hasItem:@"gun"] || isGunCollected == TRUE)
            return @"Opening the drawer reveals a bloodstained pair of gloves.";
        else
            return @"You pull open the top dresser drawer and find a gun stashed neatly inside, along with a bloodstained pair of gloves.";
    }
    if ([subject isEqualToString:@"bed"])
    {
        if ([Player hasItem:@"pillow"] || isPillowCollected == TRUE)
            return @"It looks oddly bare without a pillow, even with the comforter.";
        else
            return @"The bed looks to be rather comfortable, although not flashy in any way. It has a single pillow and a modest comforter.";
    }
    if ([subject isEqualToString:@"dresser"])
    {
        return @"There's a dresser here with a mirror attached to it so that one may inspect their appearance while they dress.  It has several draws in it to hold clothing.";
    }
    if ([subject isEqualToString:@"desk"])
    {
        return @"There's a desk with various scraps of paper and pencils strewn all about.  A few books as well, just light reading material really.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"hallway"])
    {
        return [Player setCurrentLocation:@"CabinHallwayLocation"];
    }
    return [super go:subject];
}


+ (NSString*) get:(NSString *)subject
{
    BOOL isGunCollected = [(NSNumber*)[Player attributeValue:@"gunCollected"] boolValue];
    BOOL isPencilCollected = [(NSNumber*)[Player attributeValue:@"pencilCollected"] boolValue];
    BOOL isPillowCollected = [(NSNumber*)[Player attributeValue:@"pillowCollected"] boolValue];
    
    if(![Player hasItem:subject])
    {
        if ([subject isEqualToString:@"gun"] && isGunCollected == FALSE)
        {
            [Player giveItem:@"gun"];
            [Player setAttribute:@"gunCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You pull open the dresser drawer and take the gun out.";
        }
        if ([subject isEqualToString:@"pillow"] && isPillowCollected == FALSE)
        {
            [Player giveItem:@"pillow"];
            [Player setAttribute:@"pillowCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You pick the pillow up off the bed and smooth out the comforter to look good without the pillow.  It doesn't help very much, the bed just looks empty without the pillow.";
        }
        if ([subject isEqualToString:@"pencil"] && isPencilCollected == FALSE)
        {
            [Player giveItem:@"pencil"];
            [Player setAttribute:@"pencilCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You walk over to the desk and pick up one of the pencils. As you do so a scrap of paper catches your eye, and bending over it you read \"The three items must be brought in order to cleanse the sealed gateway.\"";
        }
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
    return @"A cat pops out from under the dresser and jumps up and try to grab at the drawer handle, but falls in an amusing way.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
