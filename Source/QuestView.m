//
//  QuestView.m
//  Quest2
//
//  Created by Nathan Swenson on 12/07/10.
//  Copyright 2010 Nathan Swenson. All rights reserved.
//

#import "QuestView.h"


@implementation QuestView

@synthesize textView=_textView;
@synthesize inputField=_inputField;
@synthesize delegate=_delegate;
@synthesize whatWouldstThouDeauField=_whatWouldstThouDeauField;
@synthesize imageView = _imageView;

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
	{
    }
    return self;
}

-(IBAction)textWasEntered:(id)sender
{
	if(_delegate!=nil)[_delegate textWasEntered:[sender stringValue]];
	[sender setStringValue:@""];
}

@end
