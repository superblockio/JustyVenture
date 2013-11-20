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
@property (nonatomic, strong) NSTimer *typingTimer;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.questView.delegate = self;
    self.questView.whatWouldstThouDeauField.stringValue = @"What wouldst thou deau?";
    self.currentOutput = [[JustyVenture mainVenture] introText];
    self.window.title = [[JustyVenture mainVenture] adventureTitle];
    [self startTyping];
}

- (void)textWasEntered:(NSString *)input {
    if (input && [input length] > 0) {
        self.currentOutput = [[JustyVenture mainVenture] runUserInput:input];
        self.questView.whatWouldstThouDeauField.stringValue = [[JustyVenture mainVenture] promptText];
        [self startTyping];
    }
}

- (void)startTyping {
    self.typingIndex = 0;
    if (self.typingTimer) {
        [self.typingTimer invalidate];
    }
    self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:1/32.0f target:self selector:@selector(typeLetter) userInfo:nil repeats:YES];
}

- (void)typeLetter {
    if (self.typingIndex <= self.currentOutput.length) {
        [self.questView.textView setStringValue:[self.currentOutput substringToIndex:self.typingIndex]];
    }
    else {
        [self.typingTimer invalidate];
        self.typingIndex = 0;
    }
    self.typingIndex++;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end