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
    return @"";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    if ([verb isEqualToString:@"give"] && [Player hasItem:subject])
    {
        if ([subject isEqualToString:@"matchbox"])
        {
            return @"You throw the matchbox into the pool and get back a matchbox full of wet, useless matches. What did you expect?";
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
