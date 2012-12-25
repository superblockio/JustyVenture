//
//  CabinBathroomLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "CabinBathroomLocation.h"

@implementation CabinBathroomLocation

+ (NSString*) arrive
{
    return @"You step into the rather small bathroom. It's just a tad bit cramped, with a sink and mirror on one side next to the toilet and a shower/tub combination on the other side.  There's a little window on the south wall.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"";
    }
    if ([subject isEqualToString:@"cupboard"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"shower"])
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
    return [super get:subject];
}


+ (NSString*) get:(NSString *)subject
{
    if ([subject isEqualToString:@"soap"])
    {
        [Player giveItem:@"soap"];
        return @"You lean into the shower and pick up the soap.";
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
    return @"A cat jumps through the open window and lands feet deep in the shower. It goes crazy and run away into the hallway with it's fur sticking straight up.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
