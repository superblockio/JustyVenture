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
        self.items = [NSDictionary dictionary];
        self.allowDrop = TRUE;
    }
    return self;
}

@end
