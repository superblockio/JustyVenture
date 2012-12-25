//
//  IntroLocation.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright (c) 2011 University of Utah. All rights reserved.
//

#import "IntroLocation.h"

@implementation IntroLocation

static BOOL _tentOffend;
static BOOL _whistleOffend;

+ (NSString*) arrive
{
    _tentOffend = FALSE;
    _whistleOffend = FALSE;
    
    [Player giveItem:@"whistle"];
    [Player giveItem:@"tent"];
    return @"You're on an epic adventure where the majority of the coolest things have already happened, but there's no point in telling you about them because you were there. After saving the world and saying teary goodbyes to your hobo sidekick, you part ways. At least you'll always have his cat whistle to remember him by. After walking for a long while and reminiscing through all the good times you can totally remember having, you come to a sudden realization that you have no idea where you are. You find yourself in a dark forest surrounded by man-eating trees that are trying desperately to convince you that their mouths are where you should sleep for the night.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil || [subject isEqualToString:@"tree"] || [subject isEqualToString:@"trees"])
    {
        if (_tentOffend == FALSE)
            return @"The man-eating trees surround you. Fortunately they can't move and appear to rely solely on social skills to lure victims to their doom. Even though the trees offer reassurances that their mouths are safe and that people sleep in there all the time, you can't help but thinking that your tent might be a competitive option as well. There are no obvious exits in this dense forest, which begs the question of how you got here in the first place. There's also a giant boulder and a stick.";
        else
            return @"";
    }
    
    else if ([subject isEqualToString:@"boulder"] || [subject isEqualToString:@"boulder"])
    {
        return @"I like that boulder. That is a nice boulder! It looks like it probably has a secret passage under it too.";
    }
    
    return [super look:subject];
}

+ (NSString*) get:(NSString *)subject
{
    if ([subject isEqualToString:@"boulder"])
        return @"You crack your knuckles, do some warm up exercises, and lift up on the boulder with great force, but to no avail. After receiving some strange looks from the nearby trees, you decide to stop.";
    if ([subject isEqualToString:@"stick"])
    {
        [Player giveItem:@"stick"];
        return @"Now you're talking! This stick is sure to be useful for something! After all, it's the only gettable item around here!";
    }
    return [super get:subject];
}

+ (NSString*) use:(NSString *)subject
{
    if (![Player hasItem:subject])
        return [super use:subject];
        
    if ([subject isEqualToString:@"whistle"])
    {
        return @"You pull out your whistle and look at the inscription: \"If you WHISTLE, they will come!\"";
    }
    if ([subject isEqualToString:@"tent"])
    {
        if (!_whistleOffend)
        {
            _tentOffend = TRUE;
            [Player removeItem:@"tent"];
            return @"As you set up camp, the trees go into a violent rage for rejecting their generous offer. It is clear that you will not get any sleep inside this tent.";
        }
        else
        {
            _whistleOffend = FALSE;
            [Player removeItem:@"tent"];
            return @"You feed the tree your mangy old tent, which gets the taste of cat hair out of its mouth. The tree forgives you and allows you access to its mouth.";
        }
    }
    if ([subject isEqualToString:@"stick"])
    {
        return @"Success! Using the stick as leverage, you're able to pry the boulder away, revealing a secret passage under-- oh nevermind, that's just dirt. How disappointing. You remove the stick and the boulder rolls back into place.";
    }
    return [super use:subject];
}

+ (NSString*) talk:(NSString *)subject
{
    return [super talk:subject];
}

+ (NSString*) whistle
{
    if(!_tentOffend)
    {
        _whistleOffend = TRUE;
        return @"A massive surge of cats comes out of nowhere and pours down the throat of the chief tree. After coughing up several hairballs, the tree becomes greatly offended at this outrage and refuses to grant you entry to its mouth on the grounds that you are a crazy cat lady.";
    }
    else
    {
        _tentOffend = FALSE;
        return @"A cat climbs out from under the boulder, bearing a cute mini DJ setup on its back. Music starts to play \" Wub Wub Wub.\" As you cover your ears and contemplate kicking the cat, you notice that the trees are starting to sway back in forth in rhythm. They thank you for introducing them to the wonders of dubstep and offer you \"safe\" passage into their mouths!";
    }
    return [super whistle];
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
