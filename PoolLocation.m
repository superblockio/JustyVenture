//
//  PoolLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "PoolLocation.h"

@implementation PoolLocation

+ (NSString*) arrive
{
    return @"I accidentally the arrive text";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"The pool is surrounded by grass and and a few stones, one of which has some writing carved into it. The whole scene seems very serene. There are small bubbles percolating up from the center of the pool. It's pretty bubbly, pretty likely magical. Magical bubbly, you know? Likely?";
    }
    else if ([subject isEqualToString:@"pool"] || [subject isEqualToString:@"bubbles"])
    {
        return @"As you stare deep into the pool, it appears to stare back into your very soul. That's deep, man.";
    }
    else if ([subject isEqualToString:@"writing"] || [subject isEqualToString:@"stone"])
    {
        return @"The carving reads: \"The Pool of Might. Give of your worldly possesions and receive a fitting reward.\" Seems Legit.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
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
    return @"A cat walks out of the forest and throws a mouse in the pool. The pool promptly jettisons the mouse back out and the cats picks it up and goes on its way.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    if (([verb isEqualToString:@"give"] || [verb isEqualToString:@"throw"]) && [Player hasItem:subject])
    {
        if ([subject isEqualToString:@"matchbox"])
        {
            [Player removeItem:@"matchbox"];
            [Player giveItem:@"screwdriver"];
            return @"You throw the matchbox into the pool and a screwdriver comes flying back out and you catch it in your hand. That's certainly interesting.";
        }
        else if ([subject isEqualToString:@"screwdriver"])
        {
            return @"You toss the screwdriver into the pool. The pool promptly ejects it back out. While the screwdriver initially appears unchanged, closer inspection reveals that an image of Sonic the Hedgehog has been etched into the plastic handle. You ponder this for a moment, and then chuckle. Well-played, pool, well-played.";
        }
    }
    else if ([verb isEqualToString:@"give"] && ![Player hasItem:subject])
    {
        return @"No giving the pool things you don't have.";
    }
    return [super wildcardWithVerb:verb subject:subject];
}

@end
