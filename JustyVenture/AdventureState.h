//
//  AdventureState.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"

@interface AdventureState : NSObject

+ (AdventureState*)sharedState;

@property (nonatomic, strong) Room *currentRoom;
@property (nonatomic, readonly) NSDictionary *rooms;
@property (nonatomic, readonly) NSDictionary *variables;
@property (nonatomic, readonly) NSDictionary *items;
@property (nonatomic, strong) NSString *introText;
@property (nonatomic, readonly) NSArray *commands;

@end
