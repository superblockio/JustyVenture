//
//  IntroLocation.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/21/11.
//  Copyright (c) 2011 University of Utah. All rights reserved.
//

#import "IntroLocation.h"

@implementation IntroLocation

+ (NSString*) arrive
{
    [Player giveItem:@"cat whistle"];
    return @"You're on an epic adventure where the majority of the coolest things have already happened, but there's no point in telling you about them because you were there. After saving the world and saying teary goodbyes to your hobo sidekick, you part ways. At least you'll always have his cat whistle to remember him by. After walking for a long while and reminiscing through all the good times you can totally remember having, you come to a sudden realization that you have no idea where you are. You find yourself in a dark forest surrounded by man-eating trees that are trying desperately to convince you that their mouths are where you should sleep for the night. There is a nice, warm-looking cabin to the EAST.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil) 
    {
        return @"Man-eating TREES surround you. Fortunately, they can't move and appear to rely solely on social skills to lure victims to their doom. Even though the trees offer reassurances that their mouths are safe and people sleep there all the time, you can't help but thinking that the CABIN is a competitive option as well.";
    }
    
    else if ([subject isEqualToString:@"trees"] || [subject isEqualToString:@"tree"])
    {
        return @"";
    }
    
    return [super look:subject];
}

+ (NSString*) get:(NSString *)subject
{

    return [super get:subject];
}

+ (NSString*) use:(NSString *)subject
{
    return [super use:subject];
}

+ (NSString*) talk:(NSString *)subject
{
    return [super talk:subject];
}

+ (NSString*) whistle
{
    return [super whistle];
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
