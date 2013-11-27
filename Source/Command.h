//
//  Command.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

//Returns a new copy of the command for use in dynamic commands.
- (id)initWithCommand:(Command*)originalCommand andSubjects:(NSArray*)subjects;

// Only for commands the user types in, or that we are pretending the user typed in
- (BOOL)respondsToVerb:(NSString*)verb subject:(NSString*)subject;

// Used for checking the dynamic command list to save time by only generating the possibilites for the inputted verb
- (BOOL)respondsToVerb:(NSString*)verb;

// For "internal" commands that the user can't directly execute (the Arrive command, commands executed on a timer, etc)
// Internal commands should only have one verb they are accessed by, which is their "internal" name
- (BOOL)respondsToInternalName:(NSString*)internalName;

@property(nonatomic, strong) NSArray *verbs;
@property(nonatomic, strong) NSArray *subjects;
@property(nonatomic, assign) BOOL internal;

// The XML body to be processed when this command executes.
@property(nonatomic, strong) NSString *result;

@end
