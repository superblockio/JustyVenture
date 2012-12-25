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
static NSTimer* _timer;
static BOOL _timeOut;

+ (NSString*) arrive
{
    _neededAction = SlideActionTypeNone;
    _actionNumber = -1;
    _timeOut = FALSE;
    _song = [[QTMovie movieNamed:@"06 Slider.mp3" error:nil] retain];
    [_song play];
    return @"You enthusastically jump head-first into the tree's gaping mouth and promptly fall down a dark hole and land on a small ledge with a bendy wooden plank twisting down into a massive cavern in front of you! Stomachs are weird. You can feel yourself slipping off the ledge, and realize you're gonna have to act fast to avoid sliding off and falling to your death! You'll need to pay attention to what the slide in front of you looks like and lean to your LEFT or RIGHT, or JUMP over obstacles as you slide.  And be careful, you'll only have time to perform one action at each junction! You'd better do something, you'll slip off any second!";
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

+ (void) timeOut
{
    _timeOut = TRUE;
}

+ (NSString*) resetSlide
{
    [_timer invalidate];
    _actionNumber = -1;
    _neededAction = SlideActionTypeNone;
    return @"You fall off the edge into the abyss! You blink and suddenly you're back and the beginning of the course, about to slip off the ledge.";
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
    
    // If they got it right (even implicitly by not entering text), pick a new one or have them win.
    if ((pickedAction == _neededAction && !_timeOut) || _actionNumber == 0)
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
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timeOut) userInfo:nil repeats:FALSE];
            returnString = [NSString stringWithFormat:@"%i / 10", _actionNumber];
        }
    }
    else
    {
        return [self resetSlide];
    }
    if ([verb isEqualToString:@"lion"] && [subject isEqualToString:@"helper"])
        returnString = @"A giant lion comes sliding in after you. It bites onto the back of your collar and sinks its claws into the wooden slide, slowing you down a bit.";
    
    return returnString;
}

@end
