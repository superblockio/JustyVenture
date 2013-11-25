//
//  Item.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

//Returns the proper description based on the number of items
- (NSString*)shortDescription:(int)quantity;
- (NSString*)longDescription:(int)quantity;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *determiner;
@property(nonatomic, assign) NSString *singularName;
@property(nonatomic, assign) NSString *pluralName;
@property(nonatomic, assign) NSString *singularDescription;
@property(nonatomic, assign) NSString *pluralDescription;

//Possible subjects used to refer to the item.
@property(nonatomic, strong) NSArray *keywords;

@end
