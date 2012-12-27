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
            return @"It's a rather simple bathroom really. Nothing too ornate or anything.  Just a bathtub with a shower curtain (it's probably also a shower), a medicine cabinet, a toilet, and a window. The windows cracked open just barely, and there's no toilet paper on the toilet paper roll. There are some towels hanging on the wall next to a slightly grimy sink. The door back into the hallway is difficult to close and doesn't lock.";
        else
            return @"It's a rather simple bathroom really. Nothing too ornate or anything.  Just a shower with a shower curtain, a medicine cabinet, a toilet, and a window. The windows cracked open just barely, and there's no toilet paper on the toilet paper roll. There's a toothbrush sitting on the side of the sink, and some towels hanging up next to it. The door back into the hallway is difficult to close and doesn't lock.";
    }
    if ([subject isEqualToString:@"mirror"])
    {
        return @"The mirror is warped and it makes you look ugly. I'm kidding, you could never look ugly. Please love me...";
    }
    if ([subject isEqualToString:@"toilet"])
    {
        return @"It's so inviting, you just want to sit on in and do your business. Unfortunately your business involves toilet paper, and given that there's none of that left you'll need to hold it a bit longer.";
    }
    if ([subject isEqualToString:@"towel"] || [subject isEqualToString:@"towels"])
    {
        return @"They're dry and hanging on a towel bar. One's pink and the other is turquoise. That seems odd given the rest of the decor of the house. Oh well.";
    }
    if ([subject isEqualToString:@"window"] || [subject isEqualToString:@"windows"])
    {
        return @"They're only open enough for a small animal to get inside, and you can't seem to be able to budge them anyway.";
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
        if (![Player hasItem:@"soap"] && ![(NSNumber*)[Player attributeValue:@"soapInPool"] boolValue])
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
    return [super go:subject];
}


+ (NSString*) get:(NSString *)subject
{
    if(![Player hasItem:subject])
    {
        if ([subject isEqualToString:@"soap"] && ![(NSNumber*)[Player attributeValue:@"soapInPool"] boolValue])
        {
            [Player giveItem:@"soap"];
            return @"You pull back the shower curtain and lean across the bathtub to pick up the soap.";
        }
        if ([subject isEqualToString:@"shaving cream"] && ![Player hasItem:@"beard"])
        {
            [Player giveItem:@"shaving cream"];
            return @"You open the medicine cabinet and take the shaving cream out, leaving it bare.";
        }
        if ([subject isEqualToString:@"toothbrush"] && ![Player hasItem:@"electric eel"])
        {
            [Player giveItem:@"toothbrush"];
            return @"You pick the toothbrush up off the side of the sink.";
        }
    }
    else if ([subject isEqualToString:@"towel"] || [subject isEqualToString:@"towels"])
        return @"You actually want such girly towels? What would you even do with them? If you want them that bad you can't have them, I'm saving you from yourself!";
    else return @"You don't need to get the same thing more than once.";
    
    return [super get:subject];
}

+ (NSString*) whistle
{
    return @"A cat jumps through the open window and lands feet deep in the shower. It goes crazy and run away into the hallway with it's fur sticking straight up.";
}

@end
