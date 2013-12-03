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
        self.singularName = @"";
        self.pluralName = @"";
        self.singularDesc = @"";
        self.pluralDesc = @"";
        self.singularDescription = @"";
        self.pluralDescription = @"";
        self.singularLook = @"";
        self.pluralLook = @"";
        self.getText = @"";
        self.dropText = @"";
        self.quantity = 1;
        self.hidden = FALSE;
        self.canDrop = TRUE;
        self.keywords = [NSArray array];
    }
    return self;
}

- (id)initWithItem:(Item*)originalItem {
    self = [super init];
    if (self) {
        self.name = originalItem.name;
        self.singularName = originalItem.singularName;
        self.pluralName = originalItem.pluralName;
        self.singularDesc = originalItem.singularDesc;
        self.pluralDesc = originalItem.pluralDesc;
        self.singularDescription = originalItem.singularDescription;
        self.pluralDescription = originalItem.pluralDescription;
        self.singularLook = originalItem.singularLook;
        self.pluralLook = originalItem.pluralLook;
        self.getText = originalItem.getText;
        self.dropText = originalItem.dropText;
        self.quantity = originalItem.quantity;
        self.hidden = originalItem.hidden;
        self.canDrop = originalItem.canDrop;
        self.keywords = originalItem.keywords;
    }
    return self;
}

- (BOOL)respondsToKeyword:(NSString *)keyword {
    BOOL respondsToKeyword = NO;
    for (int i = 0; i < self.keywords.count; i++) {
        if ([[self.keywords objectAtIndex:i] caseInsensitiveCompare:keyword] == NSOrderedSame) {
            respondsToKeyword = YES;
        }
    }
    
    return respondsToKeyword;
}

- (NSString*)shortDescription {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", self.quantity];
    
    if (self.quantity == 1 || [self.pluralName isEqualToString:@""]) {
        output = [self.singularDesc copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.singularName];
    } else {
        if ([self.pluralDesc isEqualToString:@""]) output = [self.singularDesc copy];
        else output = [self.pluralDesc copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.pluralName];
    }
    
    return output;
}

- (NSString*)longDescription {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", self.quantity];
    
    if (![self.singularDescription isEqualToString:@""]) {
    if (self.quantity == 1 || [self.pluralName isEqualToString:@""]) {
        output = [self.singularDescription copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.singularName];
    } else {
        if ([self.pluralDescription isEqualToString:@""]) output = [self.singularDescription copy];
        else output = [self.pluralDescription copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.pluralName];
    }
    } else return self.shortDescription;
    
    return output;
}

- (NSString*)lookDescription {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", self.quantity];
    
    if (self.quantity == 1 || [self.pluralName isEqualToString:@""]) {
        output = [self.singularLook copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.singularName];
    } else {
        if ([self.pluralLook isEqualToString:@""]) output = [self.singularLook copy];
        else output = [self.pluralLook copy];
        
        output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
        output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.pluralName];
    }
    
    return output;
}

@end
