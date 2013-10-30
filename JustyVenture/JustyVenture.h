//
//  JustyVenture.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"

@interface JustyVenture : NSObject <NSXMLParserDelegate>

+ (JustyVenture*)mainVenture;

@property (nonatomic, strong) Room *currentRoom;
@property (nonatomic, readonly) NSDictionary *rooms;
@property (nonatomic, readonly) NSDictionary *variables;
@property (nonatomic, readonly) NSDictionary *items;
@property (nonatomic, readonly) NSArray *commands;
@property (nonatomic, strong) NSString *introText;

// This is where all the magic happens
- (NSString*)runUserInput:(NSString*)input;

@end