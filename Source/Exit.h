//
//  Exit.h
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/26/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exit : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *keyName;
@property(nonatomic, strong) NSString *desc;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *look;
@property(nonatomic, assign) BOOL hidden;
@property(nonatomic, assign) BOOL locked;

@end
