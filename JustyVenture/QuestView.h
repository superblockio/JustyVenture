//
//  QuestView.h
//  Quest2
//
//  Created by Nathan Swenson on 12/07/10.
//  Copyright 2010 Nathan Swenson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol QuestViewTextEntered

-(void)textWasEntered:(NSString*)input;

@end

@interface QuestView : NSView 
{
	IBOutlet NSTextField* _textView;
	IBOutlet NSTextField* _inputField;
	IBOutlet NSTextField* _whatWouldstThouDeauField;
    IBOutlet NSImageView* _imageView;
	NSObject <QuestViewTextEntered>* _delegate;
}

-(IBAction)textWasEntered:(id)sender;

@property(readonly) IBOutlet NSTextField* textView;
@property(readonly) IBOutlet NSTextField* inputField;
@property(readonly) IBOutlet NSTextField* whatWouldstThouDeauField;
@property(readonly) IBOutlet NSImageView* imageView;
@property(retain) NSObject<QuestViewTextEntered>* delegate;

@end
