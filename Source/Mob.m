//
//  Mob.m
//  JustyVenture
//
//  Created by Chad Ian Anderson on 11/25/13.
//  Copyright (c) 2013 JustinTime Enterprises. All rights reserved.
//

#import "Mob.h"

@implementation Mob

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
        self.talkText = @"";
        self.currentRoomName = @"";
        self.items = [NSMutableDictionary dictionary];
        self.hidden = false;
        self.canTalk = false;
        self.canHold = false;
        self.keywords = [NSArray array];
    }
    return self;
}

- (id)initWithMob:(Mob *)originalMob {
    self = [super init];
    if (self) {
        self.name = originalMob.name;
        self.singularName = originalMob.singularName;
        self.pluralName = originalMob.pluralName;
        self.singularDesc = originalMob.singularDesc;
        self.pluralDesc = originalMob.pluralDesc;
        self.singularDescription = originalMob.singularDescription;
        self.pluralDescription = originalMob.pluralDescription;
        self.singularLook = originalMob.singularLook;
        self.pluralLook = originalMob.pluralLook;
        self.talkText = originalMob.talkText;
        self.currentRoomName = originalMob.currentRoomName;
        self.items = originalMob.items;
        self.hidden = originalMob.hidden;
        self.canTalk = originalMob.canTalk;
        self.canHold = originalMob.canHold;
        self.keywords = originalMob.keywords;
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

- (NSString*)shortDescription:(int)quantity {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", quantity];
    
    if (quantity == 1 || [self.pluralName isEqualToString:@""]) {
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

- (NSString*)longDescription:(int)quantity {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", quantity];
    
    if (![self.singularDescription isEqualToString:@""]) {
        if (quantity == 1 || [self.pluralName isEqualToString:@""]) {
            output = [self.singularDescription copy];
            
            output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
            output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.singularName];
        } else {
            if ([self.pluralDescription isEqualToString:@""]) output = [self.singularDescription copy];
            else output = [self.pluralDescription copy];
            
            output = [output stringByReplacingOccurrencesOfString:@"@quantity;" withString:quant];
            output = [output stringByReplacingOccurrencesOfString:@"@name;" withString:self.pluralName];
        }
    } else return [self shortDescription:quantity];
    
    return output;
}

- (NSString*)lookDescription:(int)quantity {
    NSString *output = @"";
    NSString *quant = [[NSString alloc] initWithFormat:@"%d", quantity];
    
    if (quantity == 1 || [self.pluralName isEqualToString:@""]) {
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
