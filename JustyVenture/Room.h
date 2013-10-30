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

@end
