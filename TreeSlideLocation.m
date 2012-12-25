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
    return @"You enthusastically jump head-first into the tree's gaping mouth and find yourself sliding down a bendy wooden plank inside a massive underground cavern at breakneck speeds! Stomachs are weird. You'll need quick reflexes to avoid being thrown off into the abyss! Type LEFT, RIGHT, NONE, or JUMP based on what image is shown. Type START to start!";
}

+ (NSString*) whistle
{
    if (_actionNumber == -1)
    {
        [Player setCurrentImage:[NSImage imageNamed:@"slideforward"]];
        return @"A giant lion comes sliding in after you. It bites onto the back of your collar and sinks its claws into the wooden slide, slowing you down a bit. Type anything else to start now.";
    }
    else return [self wildcardWithVerb:@"none" subject:@""];
}

+ (NSString*) look:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@""];
}

+ (NSString*) get:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@""];
}

+ (NSString*) talk:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@""];
}

+ (NSString*) use:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@""];
}

+ (NSString*) go:(NSString*) subject
{
    return [self wildcardWithVerb:@"none" subject:@""];
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
    
    // If they got it right, pick a new one.
    if (pickedAction == _neededAction)
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
    else
    {
        _actionNumber = 0;
        _neededAction = SlideActionTypeNone;
        returnString = @"You crash! Type START to start over.";
    }
    
    return returnString;
}

@end
