//
//  QuestHandler.m
//  Quest2
//
//  Created by Nathan Swenson on 12/08/10.
//  Copyright 2010 Nathan Swenson. All rights reserved.
//

#import "QuestHandler.h"
#import "Player.h"

// Private interface
@interface QuestHandler()

- (NSString*) handleUniversalCommand:(NSString*)input; 

- (NSString*) handleRoomSpecificCommand:(NSString*)input;

@end

@implementation QuestHandler

@synthesize delegate=_delegate;

-(id)init
{
	self=[super init];
	if(self==nil)return nil;
	return self;
}

-(NSString*)outputForInput:(NSString*)input
{
    input = [input lowercaseString];
    
    // First see if it is a universal command such as "help" or "inventory". If so, handle it here.
    NSString* universalCommandOutput = [self handleUniversalCommand:input];
    if(universalCommandOutput != nil) return universalCommandOutput;
    
    // If not, pass it on to our current room to handle it.
    return [self handleRoomSpecificCommand:input];
}

// Checks to see if the input is a universal command such as "help" or "inventory". 
// If so, it is handled and the appropriate output message is returned. Otherwise,
// this method returns nil
- (NSString*) handleUniversalCommand:(NSString*)input
{
    if([input isEqualToString:@"help"] || [input isEqualToString:@"halp"])return @"In this adventure game, the standard commands are look, talk, get, drop, use, go, inventory, and help. Most of these commands expect a second word to specify what you want to get, who you want to talk to, what item to use, etc. Look can be used by itself to look at the general area or with a second word to look at a specific thing. Whistle, inventory, and help are single-word commands. Certain objects in the game may specify their own commands as well, in which case they will (hopefully) be kind enough to tell you what they are. To start over, type 'reset'.";
    if([input isEqualToString:@"inventory"])return [NSString stringWithFormat:@"Your inventory contains %@", [Player items]];
    if([input isEqualToString:@"get flask"]) return @"You cannot get ye flask. It had to house-sit for a vacationing bear who lives in a cave.";
    if([input isEqualToString:@"reset"]) return [Player softReset];
    return nil;
}

- (NSString*) handleRoomSpecificCommand:(NSString*)input
{
    // Parse out the verb and the subject. The verb is the first word and the subject is everything after that, if anything.
    NSArray* inputComponents=[input componentsSeparatedByString:@" "];
    NSString* verb = [inputComponents objectAtIndex:0];
	NSString* subject= nil;
    if([inputComponents count] > 1) subject = [input substringFromIndex:[verb length] + 1];
    
    // If the verb or subject is empty, change it to nil to make things simpler to check later
    if([verb isEqualToString:@""])verb = nil;
    if([subject isEqualToString:@""])subject = nil;
    
    // Basic error checking
    if(verb == nil) return @"You fail at word make. Type 'help' if you need it.";
    
    // Get our current room's class
    Class roomClass = NSClassFromString([Player currentRoom]);
    
    // Handle 'look'
    if([verb isEqualToString:@"look"]) return [roomClass performSelector:@selector(look:) withObject:subject];
    
    // Handle 'get'
    if([verb isEqualToString:@"get"]) return [roomClass performSelector:@selector(get:) withObject:subject];
    
    // Handle 'talk'
    if([verb isEqualToString:@"talk"]) return [roomClass performSelector:@selector(talk:) withObject:subject];
    
    // Handle 'use'
    if([verb isEqualToString:@"use"]) return [roomClass performSelector:@selector(use:) withObject:subject];
    
    // Handle 'go'
    if([verb isEqualToString:@"go"]) return [roomClass performSelector:@selector(go:) withObject:subject];
    
    // Handle 'dance'
    if([verb isEqualToString:@"whistle"]) return [roomClass performSelector:@selector(whistle)];
    
    // Handle wildcard
    return [roomClass performSelector:@selector(wildcardWithVerb:subject:) withObject:verb withObject:subject];
    
    return @"Oops you broke it. Critical error. Seriously, you should never see this. Tell me if you do.";
}

@end