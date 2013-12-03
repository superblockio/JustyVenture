//
//  AppDelegate.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/26/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "AppDelegate.h"
#import "JustyVenture.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSString *displayText;
@property (nonatomic, strong) NSString *bufferedText;
@property (nonatomic, strong) NSString *wWTDString;
@property (nonatomic, strong) NSTimer *textDelayTimer;
@property (nonatomic, strong) NSTimer *deathDelayTimer;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.questView.delegate = self;
    [[self.questView textView] setFont:[NSFont systemFontOfSize:20]];
	[[self.questView inputField] setFont:[NSFont systemFontOfSize:20]];
	[[self.questView whatWouldstThouDeauField] setFont:[NSFont systemFontOfSize:20]];
    self.wWTDString = @"";
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(updateYeTextSlowly) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.displayText = @"";
	self.bufferedText = [[JustyVenture mainVenture] introText];
    self.window.title = [[JustyVenture mainVenture] adventureTitle];
    [[JustyVenture mainVenture] setDelegate:self];
}

-(void)textWasEntered:(NSString*)text
{
	self.wWTDString = @"";
	self.displayText = @"";
    if(![self.bufferedText isEqualToString:@""])
    {
        [[self.questView textView] setStringValue:@"Woah, too fast!"];
    }
    self.bufferedText = [[JustyVenture mainVenture] runUserInput:text];
}

-(void)updateYeTextSlowly
{
	if(![self.displayText isEqualToString:_bufferedText] && ![self.bufferedText isEqualToString:@""])
	{
		int oldIndex = [self.displayText length];
		self.displayText=[self.bufferedText substringWithRange:NSMakeRange(0, oldIndex + 1)];
	}
	else
	{
		int oldWWTDIndex=[self.wWTDString length];
		if(![self.wWTDString isEqualToString:@"What wouldst thou deau?"])
		{
			self.wWTDString=[@"What wouldst thou deau?" substringWithRange:NSMakeRange(0, oldWWTDIndex + 1)];
		}
		else
		{
			self.bufferedText = @"";
		}
	}
	[[self.questView textView] setStringValue:_displayText];
	[[self.questView whatWouldstThouDeauField] setStringValue:_wWTDString];
}

-(void)failed
{
	self.deathDelayTimer=[NSTimer scheduledTimerWithTimeInterval:7.75f target:self selector:@selector(terminateApp) userInfo:nil repeats:NO];
}

-(void)cancelDeath
{
	if(self.deathDelayTimer != nil)
	{
		[self.deathDelayTimer invalidate];
		self.deathDelayTimer=nil;
	}
}

-(void)terminateApp
{
	[NSApp terminate:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end