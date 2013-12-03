//
//  Player.m
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/25/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init {
    self = [super init];
    if (self) {
        self.currentRoomName = @"";
    }
    return self;
}

@end
