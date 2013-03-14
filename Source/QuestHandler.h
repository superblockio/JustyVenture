//
//  QuestHandler.h
//  Quest2
//
//  Created by Nathan Swenson on 12/8/10.
//  Copyright 2010 Nathan Swenson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"

@protocol QuestHandlerDelegate

-(void)failed;
-(void)won;
-(void)cancelDeath;

@end


@interface QuestHandler : NSObject 
{
	NSObject <QuestHandlerDelegate>* _delegate;
}

// The heart of this adventure game. This method takes the user's input message as
// a parameter, handles the message, and then returns an output message.
-(NSString*) outputForInput:(NSString*)input;

@property(retain) NSObject<QuestHandlerDelegate>* delegate;


@end
