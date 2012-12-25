//
//  TrineLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "TrineLocation.h"

@implementation TrineLocation

static BOOL _beardUsed;
static BOOL _eelUsed;
static BOOL _grapplingHookUsed;

+ (NSString*) arrive
{
    return @"You leap into the pool and find yourself inside a whole new world, full of wonderful magic and giant snails! This place is also a forest, but has much better graphics than the one you left behind. You see three travelers. One is battling goblins, one is trying her best to reach a treasure chest through a narrow tunnel, and one is conjuring up boxes and planks in an attempt to cross a chasm.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"You are inside a magical, good graphics forest. There are three travelers. One is battling fierce goblins, one is trying her best to reach a treasure chest through a narrow tunnel, and one is conjuring up boxes and planks in an attempt to cross a chasm. Only obvious exit is back through the PORTAL.";
    }
    
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"portal"])
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
