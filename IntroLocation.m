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
    return @"You find yourself in a forest. You are surrounded by tall, man-eating trees that are trying desperately to convince you that their mouths are where you should sleep for the night.";
}

+ (NSString*) look:(NSString *)subject
{
    if (subject == nil) 
    {
        return @"The trees seem to be old and musty. You could probably outrun them if you hadn't let them surround you. Why did you do that anyway?";
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

+ (NSString*) whistle:(NSString *)subject
{
    return [super whistle:subject];
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    return [super wildcardWithVerb:verb subject:subject];
}

@end
