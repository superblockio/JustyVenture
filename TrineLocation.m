//
//  TrineLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "TrineLocation.h"

@implementation TrineLocation

static BOOL _waterUsed;
static BOOL _eelUsed;
static BOOL _hookshotUsed;

+ (NSString*) arrive
{
    return @"You walk through the portal and find yourself inside a whole new world, full of wonderful magic and giant snails! This place is also a forest, but has much better graphics than the one you left behind. You see three travelers. One is battling goblins, one is trying her best to reach a treasure chest through a narrow tunnel, and one is conjuring up boxes and planks in an attempt to cross a chasm.";
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
    return [super go:subject];
}


+ (NSString*) get:(NSString *)subject
{
    return [super get:subject];
}

+ (NSString*) use:(NSString *)subject
{
    if(![Player hasItem:subject]) return [super use:subject];
    
    if ([subject isEqualToString:@"water"])
    {
        _waterUsed = TRUE;
        [Player giveItem:@"chasm key"];
        return @"You empty your water bottle on top of a plant, causing it to grow huge and stretch across the chasm. Upon reaching the other side, Amadeus finds a small key and offers it to you as a reward.";
    }
    if ([subject isEqualToString:@"eel"])
    {
        _eelUsed = TRUE;
        [Player giveItem:@"goblin key"];
        return @"You throw Pontius your electric eel, and he uses it to embue his sword with electrical energy. Pontius makes quick work of the goblins, firing great balls of lightning from his sword. While this doesn't mesh well with your current understanding of electrictiy, you are too busy looting the fallen goblins to care. In one of their pockets, you find a small key!";
    }
    if ([subject isEqualToString:@"hookshot"])
    {
        _hookshotUsed = TRUE;
        [Player giveItem:@"chest key"];
        return @"You lend Zoya your hookshot in exchange for a portion of whatever is in the chest. She latches onto it with the hookshot and pulls it through the narrow tunnel. Inside the chest is some gold and a small key! She leaves you the key and takes the gold for herself.";
    }
    
    return [super use:subject];
}

+ (NSString*) talk:(NSString*) subject
{
    if ([subject isEqualToString:@"travelers"])
    {
        return @"You shout some words in the general direction of the travelers, but they are all too preoccupied to hear you. Maybe if you tried talking to each one individually?";
    }
    if ([subject isEqualToString:@"pontius"])
    {
        if (!_eelUsed)
            return @"Sorry, I'm a bit busy here. These goblins are putting up quite a fight! If only my sword was more powerful...";
        else
            return @"You saved me a bundle, thanks!";
    }
    else if ([subject isEqualToString:@"amadeus"])
    {
        if (![Player hasItem:@"beard"] && !_waterUsed)
            return @"It seems I'm in somewhat of a predicament. If only I had a fellow wizard to help me...";
        else if ([Player hasItem:@"beard"] && !_waterUsed)
            return @"Bless my beard! A fellow wizard! Perhaps you can help me, good sir. My friends and I need passage across this chasm but these boxes and planks are not doing the trick. The plants here react rather strongly to mystical water. Perhaps you can find us some?";
        else if (_waterUsed)
            return @"Thanks, friend!";
    }
    else if ([subject isEqualToString:@"zoya"])
    {
        if (!_hookshotUsed)
            return @"My thief insticts forbid me to leave until I can reach this chest! If only I had something that stretches and shrinks...";
        else
            return @"I'm sorry but deal was that I give you something from the chest. Well, the key is something. Now leave my gold alone!";
    }
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
