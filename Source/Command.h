//
//  Command.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

- (BOOL)respondsToVerb:(NSString*)verb subject:(NSString*)subject;

@property(nonatomic, strong) NSArray *verbs;
@property(nonatomic, strong) NSArray *subjects;

// The XML body to be processed when this command executes.
@property(nonatomic, strong) NSString *result;

@end
