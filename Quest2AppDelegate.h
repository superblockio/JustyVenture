//
//  Quest2AppDelegate.h
//  Quest2
//
//  Created by Nathan Swenson on 12/2/10.
//  Copyright 2010 Nathan Swenson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QuestView.h"
#import "QuestHandler.h"

@interface Quest2AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, QuestViewTextEntered, QuestHandlerDelegate, NSWindowDelegate> 
{
    NSWindow *_window;
	QuestView *_view;
	QuestHandler* _handler;
	NSString* _displayText;
	NSString* _bufferedText;
    NSString* _currentPrompt;
	NSString* _wWTDString;
	NSTimer* _textDelayTimer;
	NSTimer* _deathDelayTimer;
	BOOL _won;
}

-(void)updateYeTextSlowly;
-(void)terminateApp;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet QuestView* view;

@end
