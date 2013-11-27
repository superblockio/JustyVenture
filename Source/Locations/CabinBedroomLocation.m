//
//  CabinBedroomLocation.m
//  JustyVenture
//
//  Created by Chad Ian Anderson on 12/24/12.
//  Copyright 2012 Nathan Swenson. All rights reserved.
//

#import "CabinBedroomLocation.h"

@implementation CabinBedroomLocation

+ (NSString*) arrive
{
    return @"You step through the door into the bedroom, which is a bit small, has a bed in one corner, a desk in another, and a closet in the third.  There are windows on the south and west sides.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"It's a cozy little bedroom, with a bear skin rug and such. There's the bed, the dresser with a mirror on it, with all it's drawers for clothing, a work desk with books and papers on it, and some windows along the south and west sides. The doorway leading back out into the hallway is behind you.";
    }
    if ([subject isEqualToString:@"window"] || [subject isEqualToString:@"windows"])
    {
        return @"Looking out the windows you see a generator to the side of the house. That must be how it has electricity.";
    }
    if ([subject isEqualToString:@"gloves"] || [subject isEqualToString:@"bloodstained gloves"])
    {
        return @"This fine pair of black leather gloves look a little worn and are covered in blood, but they could be yours if you guess the correct price! I mean, I'm not Bob Barker I swear!";
    }
    if ([subject isEqualToString:@"books"] || [subject isEqualToString:@"book"])
    {
        return @"They're just a bunch of cheap detective novels.";
    }
    if ([subject isEqualToString:@"paper"] || [subject isEqualToString:@"papers"])
    {
        return @"There's just a mess of papers on the desk, it's nothing worth looking at.";
    }
    if ([subject isEqualToString:@"drawer"] || [subject isEqualToString:@"drawers"])
    {
        if ([Player hasItem:@"gun"] || [(NSNumber*)[Player attributeValue:@"gunCollected"] boolValue])
            return @"Opening the drawer reveals a bloodstained pair of gloves.";
        else
            return @"You pull open the top dresser drawer and find a gun stashed neatly inside, along with a bloodstained pair of gloves.";
    }
    if ([subject isEqualToString:@"bed"])
    {
        if ([Player hasItem:@"pillow"] || [(NSNumber*)[Player attributeValue:@"pillowCollected"] boolValue])
            return @"It looks oddly bare without a pillow, even with the comforter.";
        else
            return @"The bed looks to be rather comfortable, although not flashy in any way. It has a single pillow and a modest comforter.";
    }
    if ([subject isEqualToString:@"dresser"])
    {
        return @"There's a dresser here with a mirror attached to it so that one may inspect their appearance while they dress.  It has several drawers in it to hold clothing.";
    }
    if ([subject isEqualToString:@"comforter"])
    {
        return @"It's a blanket meant to keep you warm when you sleep.";
    }
    if ([subject isEqualToString:@"mirror"])
    {
        return @"You look into the mirror and see yourself. You jump back in fright and hiss, then snap out of it and slowly realize in horror that you're Chad. Suddenly you wake up from your daydream and it's just you in the mirror.";
    }
    if ([subject isEqualToString:@"desk"])
    {
        return @"There's a desk with various scraps of paper and pencils strewn all about.  A few books as well, just light reading material really.";
    }
    if ([subject isEqualToString:@"rug"] || [subject isEqualToString:@"bear rug"] || [subject isEqualToString:@"bear skin rug"])
    {
        return @"It's one of those creepy rugs that has an actual head on it.";
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
    if(![Player hasItem:subject])
    {
        if ([subject isEqualToString:@"gun"] && ![(NSNumber*)[Player attributeValue:@"gunCollected"] boolValue])
        {
            [Player giveItem:@"gun"];
            [Player setAttribute:@"gunCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You pull open the dresser drawer and take the gun out.";
        }
        if ([subject isEqualToString:@"pillow"] && ![(NSNumber*)[Player attributeValue:@"pillowCollected"] boolValue])
        {
            [Player giveItem:@"pillow"];
            [Player setAttribute:@"pillowCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You pick the pillow up off the bed and smooth out the comforter to look good without the pillow.  It doesn't help very much, the bed just looks empty without the pillow.";
        }
        if (([subject isEqualToString:@"pencil"] ||  [subject isEqualToString:@"pencils"]) && ![(NSNumber*)[Player attributeValue:@"pencilCollected"] boolValue])
        {
            [Player giveItem:@"pencil"];
            [Player setAttribute:@"pencilCollected" toValue:[NSNumber numberWithBool:TRUE]];
            return @"You walk over to the desk and pick up one of the pencils. As you do so a scrap of paper catches your eye, and bending over it you read \"The three items must be brought in order to cleanse the sealed gateway.\"";
        }
    }
    else if ([subject isEqualToString:@"glove"] || [subject isEqualToString:@"gloves"])
        return @"The blood dried them to the drawer and you can't get them unstuck.  I'm pretty sure blood can do that!  About 30% sure!";
    else if ([subject isEqualToString:@"comforter"])
        return @"We understand you're going through some difficult times, but that isn't going to help, you'll have to just continue on without it.";
    else if ([subject isEqualToString:@"paper"] || [subject isEqualToString:@"papers"])
        return @"You try to pick up the paper but it's too slippery and small for your hands. Must be photo paper or something. Photo paper covered in butter...";
    else return @"You don't need to get the same thing more than once.";
    
    return [super get:subject];
}

+ (NSString*) whistle
{
    return @"A cat pops out from under the dresser and jumps up and try to grab at the drawer handle, but falls in an amusing way.";
}

@end
