//
//  AchievementHelper.m
//  Adventure 2
//
//  Created by Nathan Swenson on 12/28/11.
//  Copyright (c) 2011 University of Utah. All rights reserved.
//

#import "AchievementHelper.h"
#import "Player.h"

@implementation AchievementHelper

+ (void) handleManeSix
{
    if([(NSNumber*)[Player attributeValue:@"talkRainbow"] boolValue] == YES &&
        [(NSNumber*)[Player attributeValue:@"talkTwilight"] boolValue] == YES &&
        [(NSNumber*)[Player attributeValue:@"talkPinkie"] boolValue] == YES &&
       [(NSNumber*)[Player attributeValue:@"talkApplejack"] boolValue] == YES &&
        [(NSNumber*)[Player attributeValue:@"talkFluttershy"] boolValue] == YES &&
       [(NSNumber*)[Player attributeValue:@"talkRarity"] boolValue] == YES) [Player achievementGet:@"the mane six"];
}

+ (void) handleChasm
{
    if([(NSNumber*)[Player attributeValue:@"chasmNathan"] boolValue] == YES &&
    [(NSNumber*)[Player attributeValue:@"chasmPortal"] boolValue] == YES &&
       [(NSNumber*)[Player attributeValue:@"chasmBoots"] boolValue] == YES) [Player achievementGet:@"chasm master"];
}

@end
