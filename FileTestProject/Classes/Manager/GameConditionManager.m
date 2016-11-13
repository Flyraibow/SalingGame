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
#import "GameValueManager.h"

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
    NSString *string = nil;
    BOOL strFlag = NO;
    ConditionData *condition = [_conditionDictionary objectForKey:conditionId];
    if ([condition.type isEqualToString:@"guild"]) {
        if ([condition.subtype isEqualToString:@"job"]) {
            NSInteger job = [[GameValueManager sharedValueManager] valueByType:condition.type2 subType:condition.subType2];
            for (GameNPCData *npcData in _myguild.myTeam.npcList) {
                if (npcData.job == job) {
                    return YES;
                }
            }
            return NO;
        }
    } else if ([condition.type isEqualToString:@"and"]) {
        return [self checkConditions:condition.type2];
    } else if ([condition.type isEqualToString:@"cacheString"]) {
        strFlag = YES;
        string = [[GameValueManager sharedValueManager] stringByKey:condition.subtype];
    }
    if (!strFlag) {
        // Normal cases, it maybe other situation, but now there is no other condition
        value = [[GameValueManager sharedValueManager] valueByType:condition.type subType:condition.subtype];
    } else {
        value = string;
    }
    
    NSInteger compareValue = [[GameValueManager sharedValueManager] valueByType:condition.type2 subType:condition.subType2];
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
