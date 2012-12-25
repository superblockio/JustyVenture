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
    return @"You step into a small bathroom that's just got a shower, a toilet, and a sink.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
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
