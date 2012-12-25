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
    return @"You step into the rather small bathroom. It's just a tad bit cramped, with a sink and mirror on one side next to the toilet and a bathtub on the other side.  There's a little window on the south wall.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil)
    {
        if ([Player hasItem:@"toothbrush"])
            return @"It's a rather simple bathroom really. Nothing too ornate or anything.  Just a bathtub with a shower curtain (it's probably also a shower), a medicine cabinet, a toilet, and a window. The windows cracked open just barely, and there's no toilet paper on the toilet paper roll. There some towels hanging on the wall next to a slightly grimy sink.";
        else
            return @"It's a rather simple bathroom really. Nothing too ornate or anything.  Just a shower with a shower curtain, a medicine cabinet, a toilet, and a window. The windows cracked open just barely, and there's no toilet paper on the toilet paper roll. There's a toothbrush sitting on the side of the sink, and some towels hanging up next to it.";
    }
    if ([subject isEqualToString:@"cabinet"] || [subject isEqualToString:@"medicine cabinet"])
    {
        if ([Player hasItem:@"shaving cream"])
            return @"You open the cabinet and find it completely empty.";
        else
            return @"You open the cabinet and find to your surprise that it's completely empty except for a can of shaving cream.";
    }
    if ([subject isEqualToString:@"bathtub"] || [subject isEqualToString:@"shower"])
    {
        if ([Player hasItem:@"soap"])
            return @"You pull back the shower curtain to reveal a grimy tub with a bar of soap sitting on the side and just a small amount of water in the bottom.";
        else
            return @"Pulling back the shower curtain reveals a bathtub with just a scant amount of water in the bottom.";
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
        return @"You pull back the shower curtain and lean across the bathtub to pick up the soap.";
    }
    if ([subject isEqualToString:@"shaving cream"])
    {
        [Player giveItem:@"shaving cream"];
        return @"You open the medicine cabinet and take the shaving cream out, leaving it bare.";
    }
    if ([subject isEqualToString:@"toothbrush"])
    {
        [Player giveItem:@"toothbrush"];
        return @"You pick the toothbrush up off the side of the sink.";
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
