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
    self.speed = 1/42.0f;
    [self startTyping];
}

- (void)textWasEntered:(NSString *)input {
    if (input && [input length] > 0) {
        self.currentOutput = [[JustyVenture mainVenture] runUserInput:input];
        self.questView.whatWouldstThouDeauField.stringValue = [[JustyVenture mainVenture] promptText];
        if ([[JustyVenture mainVenture] shibe]) {
            self.questView.textView.textColor = [NSColor colorWithCalibratedRed:0 green:0 blue:1 alpha:1];
            self.questView.textView.font = [NSFont fontWithName:@"Comic Sans MS" size:15];
            self.questView.textView.drawsBackground = FALSE;
            self.questView.whatWouldstThouDeauField.drawsBackground = FALSE;
            self.speed = 1/84.0f;
        }
        else {
            self.questView.textView.textColor = [NSColor colorWithCalibratedRed:0 green:0.863 blue:0 alpha:1];
            self.questView.textView.font = [NSFont fontWithName:@"Andale Mono" size:15];
            self.questView.textView.drawsBackground = TRUE;
            self.questView.whatWouldstThouDeauField.drawsBackground = TRUE;
            self.speed = 1/42.0f;
        }
        [self startTyping];
    }
}

- (void)startTyping {
    self.typingIndex = 0;
    if (self.typingTimer) {
        [self.typingTimer invalidate];
    }
    self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:self.speed target:self selector:@selector(typeLetter) userInfo:nil repeats:YES];
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