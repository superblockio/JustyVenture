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
    return @"You entered the Twilight Zone! Luckily it is the FiM Twilight, not the vampire variety. Still, this is a default response and you shouldn't see it when you enter a valid place. So yeah, I'm not sure what's up. *shrugpony*";
}

// The default behavior for "look"
+ (NSString*) look:(NSString*) subject
{
    if(subject != nil) 
        return [NSString stringWithFormat:@"Don't look at %@ like that, it is very shy and self-conscious!", subject];
    else
    {
        [Player setCurrentImage:[NSImage imageNamed:@"twilight.jpeg"]];
        return @"You're totes in the Twilight Zone, probably no way out. Sorry about that. Luckily it is the FiM Twilight, not the vampire variety.";
    }

}

// The default behavior for "get"
+ (NSString*) get:(NSString*) subject
{
    if(subject != nil) return [NSString stringWithFormat:@"Pockets are no place for a mighty %@!", subject];
    else return @"Aha! You didn't specify anything to get, so that means I get to fill in the blank. I choose 'get that Rainbow Dash is best pony'                             \nYou got it!";
}

// The default behavior for "talk"
+ (NSString*) talk:(NSString*) subject
{
    if(subject != nil)return [NSString stringWithFormat:@"%@ isn't talking to you. It must still be mad after what you said to it at the Christmas party....... jerk.", subject];
    else return @"Ok fine, I'll talk! I admit it, Fluttershy is best pony!\n                \n            \n            \njk";
}

+ (NSString*) use:(NSString*) subject
{
    if(subject != nil)
    {
        if([Player hasItem:subject]) return @"Professor Oak: 'There's a time and place for everything! But not now.' Wait, how did Professor Oak get here? Oh, he's just a disembodied voice. That's sorta creepy. But informative!";
       else return @"You no has.";
    }
    else return @"You didn't specify anything to use, looks like I get to fill in the blank. Let's see...               \nUse Lugia            \nLugia used Aero Blast!                  \nSome stuff probably exploded.                    \nOh noes, Team Cipher is trying to catch your Lugia and turn it to the dark side!                     \nAnd now Team Rocket is joining in as well.                    \nAnd Luna randomly popped out and shouted 'The trouble has been doubled!'               \nThis looks pretty ugly. Looks like you're gonna have to juuump!                \nOk, I've had too much fun with this. Moral of the story: don't let me fill in the blanks for you!";
}

+ (NSString*) go:(NSString*) subject
{
    if([subject isEqualToString:@"insane"])
    {
        return [Player setSaneLocation:@"InsaneLocation"];
    }
    else if(subject != nil) return [NSString stringWithFormat:@"You can't go to %@, it is under construction.                 \n                    \nYup, construction.                \n                \nThat's my story and I'm stickin' to it!", subject];
    else return @"You might want to be a little more specific there, sugar cube. Maybe you meant 'go insane'? 'go ponyville'? 'go Rainbow Dash'? Yeah you probably meant 'go Rainbow Dash'.";
}

// This method is called when an unrecognized verb gets used.
// Subclasses should override this to support additional commands.
+ (NSString*) wildcardWithVerb:(NSString*)verb subject:(NSString*)subject
{
    if(subject != nil)return [NSString stringWithFormat:@"You attempt to %@ the %@ but it-What's wrong with you!?  Why would even try such a thing?!  You need some serious HELP man.", verb, subject];
    return @"What you say?! Type 'help' if you need it.";
}

@end
