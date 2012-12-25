//
//  CabinFireplaceLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "CabinFireplaceLocation.h"

@implementation CabinFireplaceLocation

+ (NSString*) arrive
{
    return @"You tumble down another hole and land in a heap in a cramped little space. Moving into a crouch you see a crawl space in front of you that appears to lead into some sort of cabin, and an old man squatting next to you.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"The crawl space looks small, but you think you'll be able to fit. The old man looks to be playing some sort of game on his phone and isn't really paying all that much attention to you. He's sitting next to a pile of salt.";
    }
    if ([subject isEqualToString:@"salt"])
    {
        return @"All of your attempts look directly at the pile of salt fail and you're forced to look at it out of the corner of your eye. It's your standard run of the mill pile of salt, nothing much to say about it. Probably the result of one of those pesky hurricanes... inside... a fireplace. Yep, sticking with that story.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"crawl space"])
    {
        return [Player setCurrentLocation:@"CabinLocation"];
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
    if ([subject isEqualToString:@"old man"])
    {
        return @"Why won't you leave me alone! Every year around Christmas you show up on one of your adventures and interupt my peace!  Can't an old man crouch is strange places and play with his phone in peace!?";
    }
    return [super talk:subject];
}

+ (NSString*) whistle
{
    return @"Blowing your whistle causes cats to come rushing in from the holes too small for you to crawl in on the walls and running out through the one you can fit into.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
