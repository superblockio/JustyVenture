//
//  TreeSlideLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "TreeSlideLocation.h"
#import <QTKit/QTKit.h>

@implementation TreeSlideLocation

typedef enum
{
    SlideActionTypeLeft,
    SlideActionTypeRight,
    SlideActionTypeNone,
    SlideActionTypeJump
} SlideActionType;

static int _actionNumber;
static QTMovie* _song;
static SlideActionType _neededAction;

+ (NSString*) arrive
{
    _neededAction = SlideActionTypeNone;
    _actionNumber = -1;
    _song = [[QTMovie movieNamed:@"06 Slider.mp3" error:nil] retain];
    [_song play];
    [Player setCurrentImage:[NSImage imageNamed:@"slideforward"]];
    return @"You enthusastically jump head-first into the tree's gaping mouth and promptly fall down a dark hole and land on a small ledge with a bendy wooden plank twisting down into a massive cavern in front of you! Stomachs are weird. You can feel yourself slipping off the ledge, and realize you're gonna have to act fast to avoid sliding off and falling to your death.! You'll need to lean to your LEFT or RIGHT and jump over obstacles as you slide, but you might get a chance to do things while it's straight. You'd better do something, you'll slip off any second!";
}

+ (NSString*) whistle
{
    if (_actionNumber == -1)
    {
        return [self wildcardWithVerb:@"lion" subject:@"helper"];
    }
    else return [self wildcardWithVerb:@"none" subject:@"whistle"];
}

+ (NSString*) look:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@"look"];
}

+ (NSString*) get:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@"get"];
}

+ (NSString*) talk:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@"talk"];
}

+ (NSString*) use:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@"use"];
}

+ (NSString*) go:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@"go"];
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    _actionNumber++;
    SlideActionType pickedAction = SlideActionTypeNone;
    if ([verb isEqualToString:@"left"])
        pickedAction = SlideActionTypeLeft;
    else if ([verb isEqualToString:@"right"])
        pickedAction = SlideActionTypeRight;
    else if ([verb isEqualToString:@"jump"])
        pickedAction = SlideActionTypeJump;
    
    NSString* returnString = @"Oops, error happened.";
    
    if ([verb isEqualToString:@"lion"] && [subject isEqualToString:@"helper"])
        returnString = @"A giant lion comes sliding in after you. It bites onto the back of your collar and sinks its claws into the wooden slide, slowing you down a bit. This pushes you off the ledge and you start sliding down.";
    
    // If they got it right, pick a new one.
    if (pickedAction == _neededAction)
    {
        if (_actionNumber == 10)
        {
            return [Player setCurrentLocation:@"CabinLocation"];
        }
        else
        {
            int rando = floor(drand48() * 4);
            switch (rando)
            {
                case 0:
                    _neededAction = SlideActionTypeLeft;
                    [Player setCurrentImage:[NSImage imageNamed:@"slideleft"]];
                    break;
                    
                case 1:
                    _neededAction = SlideActionTypeRight;
                    [Player setCurrentImage:[NSImage imageNamed:@"slideright"]];
                    break;
                    
                case 2:
                    _neededAction = SlideActionTypeJump;
                    [Player setCurrentImage:[NSImage imageNamed:@"slidewailmer"]];
                    break;
                    
                default:
                    _neededAction = SlideActionTypeNone;
                    [Player setCurrentImage:[NSImage imageNamed:@"slideforward"]];
                    break;
            }
        }
    }
    else
    {
        _actionNumber = -1;
        _neededAction = SlideActionTypeNone;
        [Player setCurrentImage:[NSImage imageNamed:@"slideforward"]];
        returnString = @"You fall off the edge into the abyss! You blink and suddenly you're back and the beginning of the course, about to fall off the ledge.";
    }
    
    return returnString;
}

@end
