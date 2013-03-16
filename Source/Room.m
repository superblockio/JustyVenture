//
//  Room.m
//  JustyVenture
//
//  Created by Chad Ian Anderson on 03/15/13.
//  Copyright 2013 Nathan Swenson. All rights reserved.
//

#import "Room.h"

@implementation Room

+ (NSString*) arrive
{
    return @"You find yourself sitting at your computer, completely unable to do anything but stare at the screen because you're so entranced by how amazing Nathan's challenges are.  You should probably get that looked at, that's not healthy bro.  You're supposed to play the game, not break it.";
}

// The default behavior for "look"
+ (NSString*) look:(NSString*) subject
{
    if(subject != nil) 
        return [NSString stringWithFormat:@"Can you even see any %@? Well there isn't any here, so stop seeing it you crazy person! >:(", subject];
    else
    {
        return @"That's not what I meant when I told you to get it looked at. Go to a doctor, get a checkup. If you can get Doctor Swenson, he likes to keep track of all the patients with acute being-where-they're-not-supposed-to-be syndrome.";
    }
    
}

// The default behavior for "get"
+ (NSString*) get:(NSString*) subject
{
    if(subject != nil) return [NSString stringWithFormat:@"Pockets are no place for a mighty %@!", subject];
    else return @"There's nothing to get, which just reminds you that no one gets you, and makes you want to cut yourself.\n \nWeirdo.";
}

// The default behavior for "talk"
+ (NSString*) talk:(NSString*) subject
{
    if(subject != nil)return [NSString stringWithFormat:@"%@ isn't talking to you. It must still be mad after what you said about its mother....... jerk.", subject];
    else return @"Talking to yourself isn't usually considered socially acceptable behavior, but I suppose there isn't anything I can do to stop you.";
}

+ (NSString*) use:(NSString*) subject
{
    if(subject != nil)
    {
        if ([subject isEqualToString:@"whistle"]) return @"You pull out your whistle and look at the inscription: \"If you WHISTLE, they will come!\"";
        else if([Player hasItem:subject]) return @"Professor Oak: 'There's a time and place for everything! But not now.'\nWait no, that's just Chad impersonating Professor Oak. Yeah, it's totally Chad doing it, not me.";
        else return [NSString stringWithFormat:@"Your attempts to use your imaginary %@ amuse no one but yourself.", subject];
    }
    else return @"You probably think you're a hoot, trying to use nothing.  That would be funny if it weren't so sad.";
}

+ (NSString*) go:(NSString*) subject
{
    if(subject != nil) return [NSString stringWithFormat:@"You can't go to %@, it was demolished to make way for a hyperspace bypass.\n\nYup, bypass.\n\nThat's my story and I'm stickin' to it!", subject];
    else return @"I'm gonna need you to work with me here. I can't send you anywhere if you don't tell me where it is you need sending.  Or was that a command for me? Are you trying to tell me to go away? Well too bad, I'm busy narrating, now leave me alone.";
}

+ (NSString*) whistle
{
    return @"You lift the whistle to your lips and blow it, but still seem unable to unglue your eyes from your computer.  Some cats come into your room and just sit there watching you on the computer.";
}


// This method is called when an unrecognized verb gets used.
// Subclasses should override this to support additional commands.
+ (NSString*) wildcardWithVerb:(NSString*)verb subject:(NSString*)subject
{
    if(subject != nil)return [NSString stringWithFormat:@"You attempt to %@ the %@ but it-What's wrong with you!?  Why would even try such a thing?!  You need some serious HELP man.", verb, subject];
    return @"What you say?! Type 'help' if you need it.";
}

@end
