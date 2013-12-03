//
//  AppDelegate.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/26/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QuestView.h"
#import "JustyVenture.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, QuestViewTextEntered, JustyVentureDelegate>

-(void)terminateApp;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet QuestView *questView;
@property (assign) IBOutlet JustyVenture *justyVenture;
@property (nonatomic, strong) NSString *currentOutput;
@property (assign) int typingIndex;

@end
