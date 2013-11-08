//
//  Command.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Command.h"

@implementation Command

- (id)init {
    self = [super init];
    if (self) {
        self.verbs = [NSArray array];
        self.subjects = [NSArray array];
        self.internal = NO;
        self.result = @"";
    }
    return self;
}

- (BOOL)respondsToVerb:(NSString *)verb subject:(NSString *)subject {
    if (self.internal) {
        return NO;
    }
    BOOL respondsToVerb = NO;
    BOOL respondsToSubject = NO;
    for (int i = 0; i < self.verbs.count; i++) {
        if ([[self.verbs objectAtIndex:i] caseInsensitiveCompare:verb] == NSOrderedSame) {
            respondsToVerb = YES;
        }
    }
    if (([self.subjects count] == 0 && [subject isEqualToString:@""]) ||
        ([self.subjects count] == 1 && [[self.subjects objectAtIndex:0] isEqualToString:@"*"] && ![subject isEqualToString:@""])){
        respondsToSubject = YES;
    }
    else {
        for (int i = 0; i < self.subjects.count; i++) {
            if ([[self.subjects objectAtIndex:i] caseInsensitiveCompare:subject] == NSOrderedSame) {
                respondsToSubject = YES;
            }
        }
    }
    
    return respondsToVerb && respondsToSubject;
}

- (BOOL)respondsToInternalName:(NSString *)internalName {
    if (self.internal &&
        self.verbs.count == 1 &&
        [[self.verbs objectAtIndex:0] caseInsensitiveCompare:internalName] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

@end
