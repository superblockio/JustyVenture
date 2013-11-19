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

@property (nonatomic, strong) NSString *currentRoomName;
@property (nonatomic, readonly) NSMutableDictionary *rooms;
@property (nonatomic, readonly) NSMutableDictionary *variables;
@property (nonatomic, readonly) NSMutableDictionary *items;
@property (nonatomic, readonly) NSMutableArray *commands;
@property (nonatomic, strong) NSString *introText;

// This is where all the magic happens
- (NSString*)runUserInput:(NSString*)input prompt:(BOOL)prompt;

@end