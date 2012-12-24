//
//  Achievement.h
//  Adventure 2
//
//  Created by Nathan Swenson on 12/28/11.
//  Copyright (c) 2011 University of Utah. All rights reserved.
//

#import "Location.h"

@interface Achievement : NSObject

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSString* hint;
@property(nonatomic, assign) BOOL achieved;

@end
