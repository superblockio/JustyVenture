//
//  Item.h
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

//Returns a new copy of the items we have stored globally.
- (id)initWithItem:(Item*)originalItem;

//Returns the proper description based on the number of items
- (NSString*)shortDescription;
- (NSString*)longDescription;
- (NSString*)lookDescription;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *singularName;
@property(nonatomic, strong) NSString *pluralName;
@property(nonatomic, strong) NSString *singularDesc;
@property(nonatomic, strong) NSString *pluralDesc;
@property(nonatomic, strong) NSString *singularDescription;
@property(nonatomic, strong) NSString *pluralDescription;
@property(nonatomic, strong) NSString *singularLook;
@property(nonatomic, strong) NSString *pluralLook;
@property(nonatomic, assign) int quantity;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL canDrop;

//Possible subjects used to refer to the item.
@property(nonatomic, strong) NSArray *keywords;

@end
