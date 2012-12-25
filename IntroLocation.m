//
//  IntroLocation.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright (c) 2011 University of Utah. All rights reserved.
//

#import "IntroLocation.h"

@implementation IntroLocation

static BOOL _tentOffend = FALSE;
static BOOL _whistleOffend = FALSE;
static BOOL _accessGranted = FALSE;

+ (NSString*) arrive
{
    [Player giveItem:@"whistle"];
    [Player giveItem:@"tent"];
    return @"You're on an epic adventure where the majority of the coolest things have already happened, but there's no point in telling you about them because you were there. After saving the world and saying teary goodbyes to your hobo sidekick, you part ways. At least you'll always have his cat whistle to remember him by. After walking for a long while and reminiscing through all the good times you can totally remember having, you come to a sudden realization that you have no idea where you are. Looking around you find that you're in a dark forest surrounded by man-eating trees that are trying desperately to convince you that their mouths are where you should sleep for the night.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil || [subject isEqualToString:@"tree"] || [subject isEqualToString:@"trees"])
    {
        if (_tentOffend == FALSE && _whistleOffend == FALSE && _accessGranted == FALSE)
        {
            return @"The man-eating trees surround you. Fortunately they can't move and appear to rely solely on social skills to lure victims to their doom. Even though the trees offer reassurances that their mouths are safe and that people sleep in there all the time, you can't help but thinking that your tent might be a competitive option as well. There are no obvious exits in this dense forest, which begs the question of how you got here in the first place. There's also a giant boulder and a stick.";
        }
        else if (_tentOffend == TRUE)
        {
            return @"";
        }
        else if (_whistleOffend == TRUE)
        {
            return @"";
        }
        else if (_accessGranted == TRUE)
        {
            return @"";
        }
    }
    
    else if ([subject isEqualToString:@"boulder"])
    {
        return @"I like that boulder. That is a nice boulder! It looks like it probably has a secret passage under it too.";
    }
    
    else if ([subject isEqualToString:@"stick"])
    {
        return @"It's what appears to be the greatest stick in the world.  Look at it just sitting there, all stick-like and... sticky?  It's a stick, what do you want from me?";
    }
    
    return [super look:subject];
}

+ (NSString*) go:(NSString *)subject
{
    if ([subject isEqualToString:@"tree"])
    {
        if (_accessGranted == TRUE)
        return @"";
        else return @"";
    }
    return [super get:subject];
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
    if(![Player hasItem:subject]) return [super use:subject];
    else if ([subject isEqualToString:@"tent"])
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
            _accessGranted = TRUE;
            [Player removeItem:@"tent"];
            return @"You feed the tree your mangy old tent, which gets the taste of cat hair out of its mouth. The tree forgives you and allows you access to its mouth.";
        }
    }
    else if ([subject isEqualToString:@"stick"])
    {
        return @"Success! Using the stick as leverage, you're able to pry the boulder away, revealing a secret passage under-- oh nevermind, that's just dirt. How disappointing. You remove the stick and the boulder rolls back into place.";
    }
    return [super use:subject];
}

+ (NSString*) talk:(NSString*) subject
{
    if (subject == nil || [subject isEqualToString:@"tree"] || [subject isEqualToString:@"trees"])
    {
        if (_tentOffend == FALSE && _whistleOffend == FALSE && _accessGranted == FALSE)
        {
            return @"";
        }
        else if (_tentOffend == TRUE)
        {
            return @"";
        }
        else if (_whistleOffend == TRUE)
        {
            return @"";
        }
        else if (_accessGranted == TRUE)
        {
            return @"";
        }
    }
    return [super talk:subject];
}

+ (NSString*) whistle
{
    if(!_tentOffend)
    {
        _whistleOffend = TRUE;
        return @"A massive surge of cats comes out of nowhere and pours down the throat of the chief tree. After coughing up several hairballs, the tree becomes greatly offended at this outrage and refuses to grant you entry to its mouth on the grounds that you are a crazy cat lady.  This is certainly news to you seeing as you're clearly not a lady, and from what you can remember you're not crazy.  Although, you are standing in a grove of carnivorous, talking trees, and despite our insistence to the contrary you can't seem to remember how you got there at all.";
    }
    else
    {
        _tentOffend = FALSE;
        _accessGranted = TRUE;
        return @"A cat climbs out from under the boulder, bearing a cute mini DJ setup on its back. Music starts to play \" Wub Wub Wub.\" As you cover your ears and contemplate kicking the cat, you notice that the trees are starting to sway back in forth in rhythm. They thank you for introducing them to the wonders of dubstep and offer you \"safe\" passage into their mouths!";
    }
    return [super whistle];
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
