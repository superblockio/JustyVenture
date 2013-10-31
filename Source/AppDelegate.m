//
//  AppDelegate.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/26/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "AppDelegate.h"
#import "JustyVenture.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.questView.delegate = self;
    self.questView.whatWouldstThouDeauField.stringValue = @"What wouldst thou deau?";
    self.currentOutput = [[JustyVenture mainVenture] introText];
    [self startTyping];
}

- (void)textWasEntered:(NSString *)input {
    if (input && [input length] > 0) {
        self.currentOutput = [[JustyVenture mainVenture] runUserInput:input];
        [self startTyping];
    }
}

- (void)startTyping {
    self.typingIndex = 0;
    [NSTimer scheduledTimerWithTimeInterval:1/30.0f target:self selector:@selector(typeLetter:) userInfo:nil repeats:YES];
}

- (void)typeLetter:(NSTimer*)timer {
    self.typingIndex++;
    if (self.typingIndex <= self.currentOutput.length) {
        [self.questView.textView setStringValue:[self.currentOutput substringToIndex:self.typingIndex]];
    }
    else {
        [timer invalidate];
        self.typingIndex = 0;
    }
}

@end