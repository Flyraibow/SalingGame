//
//  GameConditionManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameConditionManager.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "GameNPCData.h"

static GameConditionManager *_sharedConditionManager;

@implementation GameConditionManager
{
    NSDictionary *_conditionDictionary;
    NSDictionary *_cityDictionary;
    MyGuild *_myguild;
    NSString *_myguildId;
    NSDictionary<NSString *, GameItemData *> *_itemDictionary;
}

+ (GameConditionManager *)sharedConditionManager
{
    if (!_sharedConditionManager) {
        _sharedConditionManager = [[GameConditionManager alloc] init];
    }
    return _sharedConditionManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _conditionDictionary = [[DataManager sharedDataManager].getConditionDic getDictionary];
        _cityDictionary = [GameDataManager sharedGameData].cityDic;
        _myguild = [GameDataManager sharedGameData].myGuild;
        _myguildId = _myguild.guildId;
        _itemDictionary = [GameDataManager sharedGameData].itemDic;
    }
    return self;
}

- (BOOL)checkConditions:(NSString *)conditions
{
    NSArray *conditionList = [conditions componentsSeparatedByString:@";"];
    for (NSString *str in conditionList) {
        if (str.length > 0 && ![self checkCondition:str]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkCondition:(NSString *)conditionId
{
    if (conditionId.length == 0) {
        return YES;
    }
    NSInteger value = 0;
    ConditionData *condition = [_conditionDictionary objectForKey:conditionId];
    if ([condition.type isEqualToString:@"city"]) {
        GameCityData *cityData = [_cityDictionary objectForKey:_myguild.myTeam.currentCityId];
        if ([condition.subtype isEqualToString:@"percentage"]) {
            value = [[cityData.guildOccupation objectForKey:_myguildId] intValue];
        } else if ([condition.subtype isEqualToString:@"totalPercentage"]) {
            for (NSNumber *val in cityData.guildOccupation) {
                value += [val intValue];
            }
        } else if ([condition.subtype isEqualToString:@"guildNumber"]) {
            value = (int)[cityData.guildOccupation count];
        } else if ([condition.subtype isEqualToString:@"signUpMoney"]) {
            value = cityData.signUpUnitValue;
        } else if ([condition.subtype isEqualToString:@"militaryInvestMoney"]) {
            value = cityData.milltaryValue;
        } else if ([condition.subtype isEqualToString:@"commerceInvestMoney"]) {
            value = cityData.commerceValue;
        }
    } else if ([condition.type isEqualToString:@"guild"]) {
        if ([condition.subtype isEqualToString:@"item"]) {
            return [[_itemDictionary objectForKey:_myguildId].guildId isEqualToString:_myguildId];
        } else if ([condition.subtype isEqualToString:@"job"]) {
            int job = [condition.parameter intValue];
            for (GameNPCData *npcData in _myguild.myTeam.npcList) {
                if (npcData.job == job) {
                    return YES;
                }
            }
            return NO;
        }
    } else if ([condition.type isEqualToString:@"and"]) {
        return [self checkConditions:condition.parameter];
    }
    NSInteger compareValue = 0;
    if ([condition.parameter isEqualToString:@"money"]) {
        compareValue = _myguild.money;
    } else {
        compareValue = [condition.parameter integerValue];
    }
    if ([condition.compareType isEqualToString:@"="]) {
        return compareValue == value;
    } else if ([condition.compareType isEqualToString:@"<"]) {
        return compareValue > value;
    } else if ([condition.compareType isEqualToString:@">"]) {
        return compareValue < value;
    } else if ([condition.compareType isEqualToString:@"<="]) {
        return compareValue >= value;
    } else if ([condition.compareType isEqualToString:@">="]) {
        return compareValue <= value;
    } else if ([condition.compareType isEqualToString:@"!="]) {
        return compareValue != value;
    }
    return NO;
}

@end
