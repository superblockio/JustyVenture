//
//  Room.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *commands;
@property(nonatomic, strong) NSArray *dynamicCommands;
@property(nonatomic, strong) NSMutableArray *mobs;
@property(nonatomic, strong) NSDictionary *containers;
@property(nonatomic, strong) NSDictionary *exits;
@property(nonatomic, strong) NSMutableDictionary *items;
@property(nonatomic, strong) NSMutableDictionary *players;
@property(nonatomic, assign) BOOL allowDrop;

@end
