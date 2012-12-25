//
//  CabinBedroomLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
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
        return @"";
    }
    if ([subject isEqualToString:@"drawer"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"bed"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"dresser"])
    {
        return @"";
    }
    if ([subject isEqualToString:@"desk"])
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
    if ([subject isEqualToString:@"gun"])
    {
        [Player giveItem:@"gun"];
        return @"You pull open the dresser drawer and take the gun out.";
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
    return @"A cat pops out from under the dresser and jumps up and try to grab at the drawer handle, but falls in an amusing way.";
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
