//
//  JustyVenture.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"
#import "Player.h"

@interface JustyVenture : NSObject <NSXMLParserDelegate>

+ (JustyVenture*)mainVenture;

@property (nonatomic, readonly) NSMutableDictionary *rooms;
@property (nonatomic, readonly) NSMutableDictionary *variables;
@property (nonatomic, readonly) NSMutableDictionary *items;
@property (nonatomic, readonly) NSMutableDictionary *players;
@property (nonatomic, readonly) NSMutableArray *commands;
@property (nonatomic, strong) NSString *introText;
@property (nonatomic, strong) NSString *promptText;
@property (nonatomic, strong) NSString *adventureTitle;

// This is where all the magic happens
- (NSString*)runUserInput:(NSString*)input;

@end