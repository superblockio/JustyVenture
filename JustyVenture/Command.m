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
    if ([self.verbs containsObject:verb] && (([self.subjects containsObject:subject] || [self.subjects containsObject:@"*"]))) {
        return YES;
    }
    
    return NO;
}

@end
