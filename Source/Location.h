//
//  Location.h
//  Adventure 2
//
//  Created by Nathan Swenson on 12/20/11.
//  Copyright 2011 Nathan Swenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Location : NSObject
{
}

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
