//
//  AdventureState.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "AdventureState.h"

@implementation AdventureState

static AdventureState *_sharedState;

+ (AdventureState*)sharedState {
    @synchronized(self) {
        if (!_sharedState) {
            _sharedState = [[AdventureState alloc] init];
        }
        return _sharedState;
    }
}

@end
