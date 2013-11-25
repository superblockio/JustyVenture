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
- (NSString*)shortDescription;
- (NSString*)longDescription;


@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *determiner;
@property(nonatomic, strong) NSString *singularName;
@property(nonatomic, strong) NSString *pluralName;
@property(nonatomic, strong) NSString *singularDescription;
@property(nonatomic, strong) NSString *pluralDescription;
@property(nonatomic, assign) int quantity;

//Possible subjects used to refer to the item.
@property(nonatomic, strong) NSArray *keywords;

@end
