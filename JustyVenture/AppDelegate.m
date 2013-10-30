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
    [self.questView.textView setStringValue:[JustyVenture mainVenture].introText];
}

- (void)textWasEntered:(NSString *)input {
    [self.questView.textView setStringValue:[[JustyVenture mainVenture] runUserInput:input]];
}

@end