//
//  Room.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Room.h"

@implementation Room

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.commands = [NSArray array];
        self.dynamicCommands = [NSArray array];
        self.mobs = [NSMutableArray array];
        self.containers = [NSDictionary dictionary];
        self.exits = [NSDictionary dictionary];
        self.items = [NSMutableDictionary dictionary];
        self.players = [NSMutableDictionary dictionary];
        self.allowDrop = TRUE;
    }
    return self;
}

@end
