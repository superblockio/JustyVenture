//
//  Mob.h
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/25/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mob : NSObject

@property(nonatomic, strong) NSMutableDictionary *items;
@property(nonatomic, strong) NSString *currentRoomName;
@property(nonatomic, strong) NSString *name;

@end
