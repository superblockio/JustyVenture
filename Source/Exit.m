//
//  Exit.m
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/26/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Exit.h"

@implementation Exit

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.destination = @"";
        self.lockDesc = @"";
        self.unlockDesc = @"";
        self.lockDescription = @"";
        self.unlockDescription = @"";
        self.lockLook = @"";
        self.unlockLook = @"";
        self.keyName = @"";
        self.unlockText = @"";
        self.badKey = @"";
        self.hidden = false;
        self.locked = false;
        self.keywords = [NSArray array];
    }
    return self;
}

- (BOOL)respondsToKeyword:(NSString *)keyword {
    BOOL respondsToKeyword = NO;
    for (int i = 0; i < self.keywords.count; i++) {
        if ([[self.keywords objectAtIndex:i] caseInsensitiveCompare:keyword] == NSOrderedSame) {
            respondsToKeyword = YES;
        }
    }
    
    return respondsToKeyword;
}

- (NSString*)shortDescription {
    if (self.locked) return self.lockDesc;
    else return self.unlockDesc;
}

- (NSString*)longDescription {
    if (self.locked) return self.lockDescription;
    else return self.unlockDescription;
}

- (NSString*)lookDescription {
    if (self.locked) return self.lockLook;
    else return self.unlockLook;
}

@end
