//
//  Item.m
//  JustyVenture
//
//  Created by Nathan Swenson on 10/29/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.determiner = @"";
        self.singularName = @"";
        self.pluralName = @"";
        self.singularDescription = @"";
        self.pluralDescription = @"";
        self.quantity=1;
        self.keywords = [NSArray array];
    }
    return self;
}

- (NSString*)shortDescription {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", self.quantity];
    
    if (self.quantity == 1) {
        output = [self.determiner stringByAppendingString:self.singularName];
    } else if ([self.pluralName isEqualToString:@""]) {
        output = [quant stringByAppendingString:self.singularName];
    } else {
        output = [quant stringByAppendingString:self.pluralName];
    }
    
    return output;
}

- (NSString*)longDescription {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", self.quantity];
    
    if (self.quantity == 1) {
        output = [self.singularDescription copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:self.determiner];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.singularName];
    } else if ([self.pluralName isEqualToString:@""]) {
        output = [self.singularDescription copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.singularName];
    } else {
        output = [self.pluralDescription copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.pluralName];
    }
    
    return output;
}

@end
