//
//  Container.h
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/26/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Container : NSObject

// To check which containers are being looked for
- (BOOL)respondsToKeyword:(NSString*)keyword;

//Returns the proper description based on whether the container is locked or not
- (NSString*)shortDescription;
- (NSString*)longDescription;
- (NSString*)lookDescription;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *lockDesc;
@property(nonatomic, strong) NSString *unlockDesc;
@property(nonatomic, strong) NSString *lockDescription;
@property(nonatomic, strong) NSString *unlockDescription;
@property(nonatomic, strong) NSString *lockLook;
@property(nonatomic, strong) NSString *unlockLook;
@property(nonatomic, strong) NSString *keyName;
@property(nonatomic, strong) NSString *unlockText;
@property(nonatomic, strong) NSString *emptyText;
@property(nonatomic, strong) NSString *badKey;
@property(nonatomic, strong) NSMutableDictionary *items;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL locked;

//Possible subjects used to refer to the item.
@property(nonatomic, strong) NSArray *keywords;

@end
