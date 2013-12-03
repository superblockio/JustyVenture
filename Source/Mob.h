//
//  Mob.h
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/25/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mob : NSObject

//Returns a new copy of the mob we have stored globally.
- (id)initWithMob:(Mob*)originalMob;

// To check which mobs are being looked for
- (BOOL)respondsToKeyword:(NSString*)keyword;

//Returns the proper description based on the number of mobs
- (NSString*)shortDescription:(int)quantity;
- (NSString*)longDescription:(int)quantity;
- (NSString*)lookDescription:(int)quantity;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *singularName;
@property(nonatomic, strong) NSString *pluralName;
@property(nonatomic, strong) NSString *singularDesc;
@property(nonatomic, strong) NSString *pluralDesc;
@property(nonatomic, strong) NSString *singularDescription;
@property(nonatomic, strong) NSString *pluralDescription;
@property(nonatomic, strong) NSString *singularLook;
@property(nonatomic, strong) NSString *pluralLook;
@property(nonatomic, strong) NSString *talkText;
@property(nonatomic, strong) NSMutableDictionary *items;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL canTalk;
@property(nonatomic, assign) BOOL canHold;

//Possible subjects used to refer to the item.
@property(nonatomic, strong) NSArray *keywords;

@end
