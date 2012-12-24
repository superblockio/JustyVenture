//
//  Location.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/20/11.
//  Copyright (c) 2011 Nathan Swenson. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (NSString*) arrive
{
    return @"You find yourself sitting at your computer, completely unable to do anything but stare at the screen because you're so entranced by how amazing Nathan's challenges are.  You should probably get that looked at, that's not healthy bro.  You're supposed to play the game, not break it.";
}

// The default behavior for "look"
+ (NSString*) look:(NSString*) subject
{
    if(subject != nil) 
        return [NSString stringWithFormat:@"Don't look at %@ like that, it is very shy and self-conscious!", subject];
    else
    {
        return @"That's not what I meant when I told you to get it looked at, have a doctor do a checkup, you need help.";
    }

}

// The default behavior for "get"
+ (NSString*) get:(NSString*) subject
{
    if(subject != nil) return [NSString stringWithFormat:@"Pockets are no place for a mighty %@!", subject];
    else return @"There's nothing to get, which just reminds you that no one gets you, and makes you want to cut yourself.\n \n Weirdo.";
}

// The default behavior for "talk"
+ (NSString*) talk:(NSString*) subject
{
    if(subject != nil)return [NSString stringWithFormat:@"%@ isn't talking to you. It must still be mad after what you did to it's mother....... jerk.", subject];
    else return @"Talking to yourself isn't usually considered socially acceptable behavior, but if you want to do it so badly go ahead.";
}

+ (NSString*) use:(NSString*) subject
{
    if(subject != nil)
    {
        if([Player hasItem:subject]) return @"Professor Oak: 'There's a time and place for everything! But not now.' Wait, how did Professor Oak get here? Oh, he's just a disembodied voice. That's sorta creepy. But informative!";
       else return @"You no has.";
    }
    else return @"You probably think you're a hoot, trying to use nothing.  That would be funny if it weren't so sad.";
}

+ (NSString*) go:(NSString*) subject
{
    if(subject != nil) return [NSString stringWithFormat:@"You can't go to %@, it is under construction.                 \n                    \nYup, construction.                \n                \nThat's my story and I'm stickin' to it!", subject];
    else return @"You might want to be a little more specific there, sugar cube. Maybe you meant 'go insane'? 'go ponyville'? 'go Rainbow Dash'? Yeah you probably meant 'go Rainbow Dash'.";
}

+ (NSString*) whistle
{
    return @"You lift the whistle to your lips and blow it, but still seem unable to glue your eyes from your computer.  Some cats come into your room and just sit there watching you on the computer.";
}


// This method is called when an unrecognized verb gets used.
// Subclasses should override this to support additional commands.
+ (NSString*) wildcardWithVerb:(NSString*)verb subject:(NSString*)subject
{
    if(subject != nil)return [NSString stringWithFormat:@"You attempt to %@ the %@ but it-What's wrong with you!?  Why would even try such a thing?!  You need some serious HELP man.", verb, subject];
    return @"What you say?! Type 'help' if you need it.";
}

@end
