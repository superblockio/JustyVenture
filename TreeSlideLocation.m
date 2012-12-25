//
//  TreeSlideLocation.m
//  JustyVenture
//
//  Created by Nathan Swenson on 12/24/12.
//
//

#import "TreeSlideLocation.h"

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
static BOOL _lion;

+ (NSString*) arrive
{
    _neededAction = SlideActionTypeNone;
    _actionNumber = -1;
    _timeOut = FALSE;
    _lion = FALSE;
    _song = [[QTMovie movieNamed:@"06 Slider.mp3" error:nil] retain];
    [_song play];
    [_song setAttribute:[NSNumber numberWithBool:YES] forKey: @"QTMovieLoopsAttribute"];
    return @"You enthusastically jump head-first into the tree's gaping mouth and promptly fall down a dark hole and land on a small ledge with a bendy wooden plank twisting down into a massive cavern in front of you! Stomachs are weird. You can feel yourself slipping off the ledge, and realize you're gonna have to act fast to avoid sliding off and falling to your death! You'll need to pay attention to what the slide in front of you looks like and lean to your LEFT or RIGHT, or JUMP over obstacles as you slide. If there are no turns or obstacles, don't enter text! And be careful, you'll only have time to perform one action at each junction, so make sure you do the right thing, or you'll fall off!";
}

+ (NSString*) whistle
{
    if (_actionNumber == -1)
    {
        _lion = TRUE;
        return @"A giant lion comes sliding in after you. It bites onto the back of your collar and sinks its claws into the wooden slide. This should slow you down a bit when you start sliding.";
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
    [Player forceInputUpdateWithString:@"none"];
}

+ (NSString*) resetSlide
{
    if (_timer != nil)
        [_timer invalidate];
    _actionNumber = -1;
    if (_neededAction == SlideActionTypeJump)
    {
        _neededAction = SlideActionTypeNone;
        return @"You hit into the Wailmer and it knocks the breath out of you causing you to slip sideways off the slide. As you fall you blink and suddenly you're back and the beginning of the course, about to slip off the ledge.";
    }
    else
    {
        _neededAction = SlideActionTypeNone;
        return @"You don't turn soon enough and fall off the edge into the abyss! You blink and suddenly you're back and the beginning of the course, about to slip off the ledge.";
    }
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
    if ((pickedAction == _neededAction && !_timeOut) || (_timeOut && _neededAction == SlideActionTypeNone) || _actionNumber == 0)
    {
        if (_actionNumber == 10)
        {
            [_song stop];
            _song = [[QTMovie movieNamed:@"Horse_Race_Finish_Line.mp3" error:nil] retain];
            [_song play];
            if (_timer != nil)
            {
                if ([_timer isValid])
                    [_timer invalidate];
                [_timer release];
            }
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
            _timeOut = FALSE;
            
            if (_timer != nil)
            {
                if ([_timer isValid])
                    [_timer invalidate];
                [_timer release];
            }
            // Calculate how much time the user has to react, based on how far we are into the game, as well as lion-have
            NSTimeInterval time = 4.0f - 0.2f * _actionNumber + (_lion ? 1.0f : 0.0f);
            
            // Add some feedback so they can see how much time they have
            returnString = [NSString stringWithFormat:@"%i / 10\nTime:", _actionNumber + 1];
            for (double i = time - 0.6666665; i > 0.0f; i-=0.0333332)
            {
                if (i < floor(i) + 0.03)
                    returnString = [returnString stringByAppendingFormat:@"\n%i", (int)floor(i)];
                else
                    returnString = [returnString stringByAppendingString:@" "];
            }
            
            _timer = [[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timeOut) userInfo:nil repeats:FALSE] retain];
        }
    }
    else
    {
        return [self resetSlide];
    }
    
    return returnString;
}

@end
