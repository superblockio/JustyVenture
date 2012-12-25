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
    return @"You step through the doorway out into the hallway.  It's a cosy little hallway with a few pictures on the wall.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        return @"";
    }
    if ([subject isEqualToString:@"painting"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"floor"])
    {
        return @"";
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
    if ([subject isEqualToString:@"entryway"])
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
