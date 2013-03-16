//
//  Quest2AppDelegate.m
//  Quest2
//
//  Created by Nathan Swenson on 12/02/10.
//  Copyright 2010 Nathan Swenson. All rights reserved.
//

#import "Quest2AppDelegate.h"
#import "Player.h"

@implementation Quest2AppDelegate

@synthesize window=_window;
@synthesize view=_view;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _currentPrompt = @"What wouldst thou deau?";
	_wWTDString=[@"" retain];
	[_view setDelegate:self];
	_handler=[[QuestHandler alloc]init];
	[[_view textView] setFont:[NSFont systemFontOfSize:20]];
	[[_view inputField] setFont:[NSFont systemFontOfSize:20]];
	[[_view whatWouldstThouDeauField] setFont:[NSFont systemFontOfSize:20]];
	NSTimer* timer=[[NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(updateYeTextSlowly) userInfo:nil repeats:YES] retain];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	_displayText=[@"" retain];
	[_window setDelegate:self];
	_bufferedText=[[Player setCurrentRoom:@"SampleRoom"] retain];
    [[_view imageView] setHidden:YES];
    [[_view imageView] setImageFrameStyle:NSImageFrameNone];
}

-(void)textWasEntered:(NSString*)text
{
	if(_wWTDString!=nil)[_wWTDString release];
	_wWTDString=[@"" retain];
	if(_displayText!=nil)[_displayText release];
	_displayText=[@"" retain];
	
    if(![_bufferedText isEqualToString:@""])
    {
        [[_view textView] setStringValue:@"Woah, too fast!"];
    }
    [_bufferedText release];
    _bufferedText=[[_handler outputForInput:text] retain];
    [_currentPrompt release];
    _currentPrompt = [[Player promptOverride] retain];
    [Player overridePrompt:nil];
    NSImage* currentImage = [Player currentImage];
    if(currentImage != nil)
    {
        [[_view imageView] setImage:currentImage];
        [[_view imageView] setHidden:NO];
    }
    else
    {
        [[_view imageView] setImage:nil];
        [[_view imageView] setHidden:YES];
    }
    [Player setCurrentImage:nil];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[self terminateApp];
}

-(void)updateYeTextSlowly
{
    if(_currentPrompt == nil) _currentPrompt = @"What wouldst thou deau?";
	if(![_displayText isEqualToString:_bufferedText] && ![_bufferedText isEqualToString:@""])
	{
		int oldIndex=[_displayText length];
		_displayText=[[_bufferedText substringWithRange:NSMakeRange(0, oldIndex+1)] retain];
	}
	else
	{
		int oldWWTDIndex=[_wWTDString length];
		if(![_wWTDString isEqualToString: _currentPrompt])
		{
			_wWTDString=[[_currentPrompt substringWithRange:NSMakeRange(0, oldWWTDIndex+1)] retain];
		}
		else
		{
			if(_bufferedText!=nil)[_bufferedText release];
			_bufferedText=[@"" retain];
		}
	}
	[[_view textView] setStringValue:_displayText];
	[[_view whatWouldstThouDeauField] setStringValue:_wWTDString];
}

-(void)terminateApp
{
	[NSApp terminate:self];
}

- (void) playerForcedInputUpdateWithString:(NSString *)string
{
    [self textWasEntered:string];
}

@end
