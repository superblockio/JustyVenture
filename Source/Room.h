//
//  Room.h
//  JustyVenture
//
//  Created by Chad Ian Anderson on 03/15/13.
//  Copyright 2013 Nathan Swenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Room : NSObject

// Subclasses should override these
+ (NSString*) arrive;
+ (NSString*) look:(NSString*) subject;
+ (NSString*) get:(NSString*) subject;
+ (NSString*) talk:(NSString*) subject;
+ (NSString*) use:(NSString*) subject;
+ (NSString*) go:(NSString*) subject;
+ (NSString*) whistle;
+ (NSString*) wildcardWithVerb:(NSString*)verb subject:(NSString*)subject;

@end
