//
//  PoolLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "PoolLocation.h"

@implementation PoolLocation

static int _keyItemsInPool;

+ (NSString*) arrive
{
    _keyItemsInPool = 0;
    return @"I accidentally the arrive text";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"The pool is surrounded by grass, some mushrooms, and and a few stones, one of which has some writing carved into it. The whole scene seems very serene. There are small bubbles percolating up from the center of the pool. It's pretty bubbly, pretty likely magical. Magical bubbly, you know? Likely?";
    }
    else if ([subject isEqualToString:@"pool"] || [subject isEqualToString:@"bubbles"])
    {
        return @"As you stare deep into the pool, it appears to stare back into your very soul. That's deep, man.";
    }
    else if ([subject isEqualToString:@"writing"] || [subject isEqualToString:@"stone"])
    {
        return @"The carving reads: \"The Pool of Might. Give of your worldly possesions and receive a fitting reward.\" Seems Legit.";
    }
    else if ([subject isEqualToString:@"mushroom"] || [subject isEqualToString:@"mushrooms"])
    {
        return @"They look like very gettable mushrooms!";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    return [super get:subject];
}

+ (NSString*) get:(NSString *)subject
{
    if ([subject isEqualToString:@"mushroom"] || [subject isEqualToString:@"mushrooms"])
    {
        [Player giveItem:@"mushroom"];
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
    return @"A cat walks out of the forest and throws a mouse in the pool. The pool promptly jettisons the mouse back out and the cats picks it up and goes on its way.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    if (([verb isEqualToString:@"give"] || [verb isEqualToString:@"throw"]) && [Player hasItem:subject])
    {
        if ([subject isEqualToString:@"screw"])
        {
            [Player removeItem:@"screw"];
            [Player giveItem:@"screwdriver"];
            return @"You throw the screw into the pool and a screwdriver comes flying back out and you catch it in your hand. That's certainly interesting.";
        }
        else if ([subject isEqualToString:@"screwdriver"])
        {
            return @"You toss the screwdriver into the pool. The pool promptly ejects it back out. While the screwdriver initially appears unchanged, closer inspection reveals that an image of Sonic the Hedgehog has been etched into the plastic handle. You ponder this for a moment, and then chuckle. Well-played, pool, well-played.";
        }
        else if ([subject isEqualToString:@"pencil"])
        {
            [Player removeItem:@"pencil"];
            return @"Swirling black lines expand across the surface of the pool from the point your pencil entered the water. These lines twist and intersect until they form... an image of Fluttershy! This is by far the cutest Fluttershy depiction you've seen in your entire life. Unfortunately, the black lines soon start to dissipate, leaving you with nothing but a memory. This has taught you a valuable lesson: next time, use a pen.";
        }
        else if ([subject isEqualToString:@"pine cone"])
        {
            [Player removeItem:@"pine cone"];
            return @"You throw in the pine cone, and with a great blue flash the pool launches a large object high into the air. You have to dodge out of the way to keep it from hitting you on its way down. After this horrific incident of terror is over, you take a look and see that it is a giant 3D cone! You can hear a soft sobbing noise coming from it, as though the cone is pining away for a long-lost loved one. 3D primatives have emotions too! These emotions are short-lived, however, as the cone wriggles its way back into the pool and gets dispersed into its depths.";
        }
        else if ([subject isEqualToString:@"shaving cream"])
        {
            [Player removeItem:@"shaving cream"];
            [Player giveItem:@"beard"];
            return @"With a mighty throw, you hurl the shaving cream into the water. The pool pauses for a moment, as if contemplating your hostility towards shaving. Then a jet of water surges out and hits you square in the head, knocking you flat on your back. As you reach for your face to wipe the water away, your hand brushes against long, flowing hair. It appears that you now have a wizard-style beard! You feel much more distinguished now, as if wisdom is oosing out of the tip of each hair. You feel as though you can solve any puzzle with ease. So go ahead, beardy, impress me!";
        }
        else if ([subject isEqualToString:@"pillow"])
        {
            [Player removeItem:@"pillow"];
            return @"A large, ornate bed materializes on the surface of the water. It has red curtains, a solid wood frame with fancy carvings in it, and a fluffy matress to send you to heaven. You hop aboard this extremely comfortable bed, almost forgetting that it is still suspended in a pool of water. This soon changes as the cold water reaches your feet and works its way to the rest of your body. You soon find yourself abandoning ship and swimming back to shore as the bed slowly sinks into the abyss. You wonder what the pool was trying to accomplish by doing all this.";
        }
        else if ([subject isEqualToString:@"toothbrush"])
        {
            [Player removeItem:@"toothbrush"];
            [Player giveItem:@"electric eel"];
            return @"You throw in the toothbrush and out pops an electric eel! A deep voice booms from within the heart of the pool: \"I was going to give you an electric toothbrush but then I started thinking of electric eels because I'm a body of water.\" You rejoice at your good fortune and promptly stuff the eel into your pants, even though it kinda stings your skin.";
        }
    }
    else if ([verb isEqualToString:@"give"] && ![Player hasItem:subject])
    {
        return @"No giving the pool things you don't have.";
    }
    return [super wildcardWithVerb:verb subject:subject];
}

@end
