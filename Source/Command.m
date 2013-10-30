//
//  Command.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Command.h"

@implementation Command

- (BOOL)respondsToVerb:(NSString *)verb subject:(NSString *)subject {
    if (self.internal) {
        return NO;
    }
    else if ([self.verbs containsObject:verb] && self.subjects == nil && subject == nil) {
        return YES;
    }
    else if ([self.verbs containsObject:verb] && (([self.subjects containsObject:subject] || [self.subjects containsObject:@"*"]))) {
        return YES;
    }
    
    return NO;
}

- (BOOL)respondsToInternalName:(NSString *)internalName {
    if (self.internal && self.verbs.count == 1 && [self.verbs objectAtIndex:0] == internalName) {
        return YES;
    }
    return NO;
}

@end
