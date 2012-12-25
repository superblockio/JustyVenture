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
    _actionNumber = 0;
    _song = [[QTMovie movieNamed:@"06 Slider.mp3" error:nil] retain];
    [_song play];
    [Player setCurrentImage:[NSImage imageNamed:@"slideforward"]];
    return @"You enthusastically jump head-first into the tree's gaping mouth and find yourself sliding down a bendy wooden plank inside a massive underground cavern at breakneck speeds! Stomachs are weird. You'll need quick reflexes to avoid being thrown off into the abyss! Type LEFT, RIGHT, NONE, or JUMP based on what image is shown. Type anything to start!";
}

+ (NSString*) whistle
{
    if (_actionNumber == 0)
    {
        return @"Several cats fly in to assist you 
    }
    return [super whistle];
}

+ (NSString*)wildcardWithVerb:(NSString *)verb subject:(NSString *)subject
{
    _actionNumber++;
    if ([verb isEqualToString:@"left"])
        _action = SlideActionTypeLeft;
    else if ([verb isEqualToString:@"right"])
        _action = SlideActionTypeRight;
    else if ([verb isEqualToString:@"jump"])
        _action = SlideActionTypeNone;
    
    
    return [super wildcardWithVerb:verb subject:subject];
}

@end
