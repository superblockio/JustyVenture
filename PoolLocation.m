//
//  PoolLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "PoolLocation.h"

@implementation PoolLocation

typedef enum
{
    PoolStateNormal,
    PoolStateGreen,
    PoolStatePortal
} PoolState;

static PoolState _poolState;

+ (NSString*) arrive
{
    [self updatePoolState];
    return @"There's a large pool of shimmering water here. It's almost completely clear, and yet it shimmers in an odd way. It's difficult to take your eyes off of it, almost like it's enchanted in some way.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        if (_poolState == PoolStateNormal)
            return @"The pool is surrounded by grass and a few large stones, one of which has some writing carved into it. The whole scene seems very serene. There are small bubbles percolating up from the center of the pool. It's pretty bubbly, pretty likely magical. Magical bubbly, you know? Likely? the CABIN is back in the cabin direction.";
        else if (_poolState == PoolStateGreen)
            return @"The pool bubbles rapidly and glows a greenish hue. It is still surrounded by grass and and a few large stones, one of which has some writing carved into it. The CABIN is back wherever.";
        else if (_poolState == PoolStatePortal)
            return @"A mysterious PORTAL has formed inside the archway on the ice island, in response to you solving the murder mystery. Yes, you understand perfectly now. It's clear that the owner of this cabin slipped on a bar of soap while in the shower, sending him into a violent rage and causing him to commit several pre-meditated murders. Then he dumped the bodies into this pool. Throwing the murder items into the pool allowed the spirits of the victims to pass on, and they made you this portal as a gift. Anyway, aside from the weird portal island the rest of the pool seems pretty normal. There's still stones and grass around and the CABIN is in a place.";
    }
    else if ([subject isEqualToString:@"pool"] || [subject isEqualToString:@"bubbles"])
    {
        return @"As you stare deep into the pool, it appears to stare back into your very soul. That's deep, man.";
    }
    else if ([subject isEqualToString:@"writing"] || [subject isEqualToString:@"stone"] || [subject isEqualToString:@"stones"])
    {
        return @"The carving reads: \"The Pool of Might. GIVE of your worldly possesions and receive a fitting reward.\" Seems Legit.";
    }
    else if ([subject isEqualToString:@"grass"])
    {
        return @"It looks like very gettable, I mean beautiful, grass.";
    }
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"cabin"])
        return [Player setCurrentLocation:@"CabinLocation"];
    else if ([subject isEqualToString:@"portal"] && _poolState == PoolStatePortal)
        return [Player setCurrentLocation:@"TrineLocation"];
    return [super go:subject];
}

+ (NSString*) get:(NSString *)subject
{
    if ([subject isEqualToString:@"grass"])
    {
        if (![Player hasItem:@"hookshot"])
        {
        [Player giveItem:@"hookshot"];
        return @"You go off the path a ways to grab some grass from the side of the pool. As you're walking, you suddenly fall into a hole! This hole is full of skeletons which you bravely fight your way through (despite them not being hostile or even in your way) and you arrive at a stone doorway where you meet the ghost of Dampe. After beating him in a race, he gives you his stretching shrinking keepsake, otherwise known as a HOOKSHOT! He returns you back to the pool.";
        }
        else
        {
            return @"You grab a tuft of grass, realize it can't possibly be important, then get bored and put it back.";
        }
    }
    else if ([subject isEqualToString:@"water"])
    {
        return @"You cup your hands and scoop up some water to put in your pants. Unfortunately, half of the water slips through your fingers and the other half gets absorbed by your pocket. Now it kinda looks like you peed your pants. If only you had something to put the water in!";
    }
    return [super get:subject];
}

+ (NSString*) use:(NSString *)subject
{
    if(![Player hasItem:subject]) return [super use:subject];
    
    if ([subject isEqualToString:@"bottle"])
    {
        [Player removeItem:@"bottle"];
        [Player giveItem:@"water"];
        return @"You dip your bottle in the pool and retrieve some WATER from it.";
    }
    
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
        // Set to true if you threw in a key item this time around
        BOOL threwKeyItem = FALSE;
        
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
        else if ([subject isEqualToString:@"soap"])
        {
            threwKeyItem = TRUE;
            [Player removeItem:@"soap"];
            [Player setAttribute:@"soapInPool" toValue:[NSNumber numberWithBool:TRUE]];
            [self updatePoolState];
        }
        else if ([subject isEqualToString:@"murder book"])
        {
            threwKeyItem = TRUE;
            [Player removeItem:@"murder book"];
            [Player setAttribute:@"murderBookInPool" toValue:[NSNumber numberWithBool:TRUE]];
            [self updatePoolState];
        }
        else if ([subject isEqualToString:@"gun"])
        {
            threwKeyItem = TRUE;
            [Player removeItem:@"gun"];
            [Player setAttribute:@"gunInPool" toValue:[NSNumber numberWithBool:TRUE]];
            [self updatePoolState];
        }
        else 
        {
            return @"Your offering is rejected and flies back into your hands, leaving you with the distinct feeling that the pool knows you'll need it later. Or maybe you're just crazy.";
        }
        
        if (threwKeyItem)
        {
            if (_poolState == PoolStatePortal)
            {
                return [NSString stringWithFormat:@"As you throw in the %@, the pool begins to erupt violently! Two jets of water shoot up from opposite ends of the pool, arching across the sky until they hit each other. The green water suddenly crystalizes into ice, forming an island with a crystal archway on it. A PORTAL to another world forms inside the archway and the rest of the water returns to normal.", subject];
            }
            else
            {
                return [NSString stringWithFormat:@"You throw the %@ into the pool and wait for a reward. Instead, the pool changes slightly in hue and begins bubbling more rapidly. You feel as though the pool is still waiting for something more.", subject];
            }
        }
    }
    else if ([verb isEqualToString:@"give"] && ![Player hasItem:subject])
    {
        return @"No giving the pool things you don't have.";
    }
    return [super wildcardWithVerb:verb subject:subject];
}

+ (void) updatePoolState
{
    if ([(NSNumber*)[Player attributeValue:@"soapInPool"] boolValue] && [(NSNumber*)[Player attributeValue:@"murderBookInPool"] boolValue] && [(NSNumber*)[Player attributeValue:@"gunInPool"] boolValue])
    {
        _poolState = PoolStatePortal;
    }
    else if ([(NSNumber*)[Player attributeValue:@"soapInPool"] boolValue] || [(NSNumber*)[Player attributeValue:@"murderBookInPool"] boolValue] || [(NSNumber*)[Player attributeValue:@"gunInPool"] boolValue])
    {
        _poolState = PoolStateGreen;
    }
    else
        _poolState = PoolStateNormal;
}

@end
