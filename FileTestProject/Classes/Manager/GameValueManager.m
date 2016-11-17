//
//  GameValueManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameValueManager.h"
#import "GameCityData.h"
#import "GameDataManager.h"
#import "LocalString.h"

static GameValueManager *_sharedValueManager;

@implementation GameValueManager
{
    NSMutableDictionary *_numDictionary;
    NSMutableDictionary *_stringDictionary;
    NSMutableDictionary *_reserveDictionary;
    NSDictionary *_cityDictionary;
    MyGuild *_myguild;
    NSString *_myguildId;
    NSDictionary<NSString *, GameItemData *> *_itemDictionary;
}

+ (GameValueManager *)sharedValueManager
{
    if (!_sharedValueManager) {
        _sharedValueManager = [[GameValueManager alloc] init];
    }
    return _sharedValueManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _numDictionary = [NSMutableDictionary new];
        _stringDictionary = [NSMutableDictionary new];
        _reserveDictionary = [NSMutableDictionary new];
        _cityDictionary = [GameDataManager sharedGameData].cityDic;
        _itemDictionary = [GameDataManager sharedGameData].itemDic;
        _myguild = [GameDataManager sharedGameData].myGuild;
        _myguildId = _myguild.guildId;
    }
    return self;
}

- (NSInteger)intByKey:(NSString *)key
{
    if ([_numDictionary objectForKey:key]) {
        return [_numDictionary[key] integerValue];
    }
    return -1;
}

- (NSString *)stringByKey:(NSString *)key
{
    id ob = [_stringDictionary objectForKey:key];
    return (ob != [NSNull null]) ? ob : nil;
}

- (NSString *)reservedStringByKey:(const NSString *)key
{
    id ob = [_reserveDictionary objectForKey:key];
    return (ob != [NSNull null]) ? ob : nil;
}

- (void)setString:(NSString *)value byKey:(NSString *)key
{
    [_stringDictionary setObject:value?:[NSNull null] forKey:key];
}

- (void)setReserveString:(NSString *)value byKey:(const NSString *)key
{
    [_reserveDictionary setObject:value?:[NSNull null] forKey:key];
}

- (void)setNum:(NSInteger)value byKey:(NSString *)key
{
    [_numDictionary setObject:@(value) forKey:key];
}

//for example money=cache.sailorNumber*cache.wage
// contain at most 1 symbol ( +, -, * )
- (void)setNumberByTerm:(NSString *)term
{
    NSArray *array = [term componentsSeparatedByString:@"="];
    NSString *key = array[0];
    NSString *valueStr = array[1];
    NSInteger value;
    if ([valueStr containsString:@"+"]) {
        NSArray *valArray = [valueStr componentsSeparatedByString:@"+"];
        value = [self getNumberByTerm:valArray[0]] + [self getNumberByTerm:valArray[1]];
    } else if ([valueStr containsString:@"-"]) {
        NSArray *valArray = [valueStr componentsSeparatedByString:@"-"];
        value = [self getNumberByTerm:valArray[0]] - [self getNumberByTerm:valArray[1]];
    } else if ([valueStr containsString:@"*"]) {
        NSArray *valArray = [valueStr componentsSeparatedByString:@"*"];
        value = [self getNumberByTerm:valArray[0]] * [self getNumberByTerm:valArray[1]];
    } else {
        value = [self getNumberByTerm:valueStr];
    }
    [self setNum:value byKey:key];
}

- (NSInteger)getNumberByTerm:(NSString *)term
{
    if ([term containsString:@"."]) {
        NSArray *valArr = [term componentsSeparatedByString:@"."];
        NSString *type = valArr[0];
        NSString *subType = valArr[1];
        return [self valueByType:type subType:subType];
    } else {
        return [term integerValue];
    }
}

- (void)setStringByTerm:(NSString *)term
{
    NSArray *array = [term componentsSeparatedByString:@"="];
    NSString *key = array[0];
    NSString *valueStr = array[1];
    [self setString:[self getStringByTerm:valueStr] byKey:key];
}

- (NSString *)getStringByTerm:(NSString *)term
{
    if ([term containsString:@"."]) {
        NSArray *valArr = [term componentsSeparatedByString:@"."];
        NSString *type = valArr[0];
        NSString *subType = valArr[1];
        return [self stringByType:type subType:subType];
    } else {
        return term;
    }
}

- (NSString *)stringByType:(NSString *)type subType:(NSString *)subType
{
    if ([type isEqualToString:@"cache"]) {
        return [self stringByKey:subType];
    } else if ([type isEqualToString:@"city"]) {
        GameCityData *cityData = [_cityDictionary objectForKey:_myguild.myTeam.currentCityId];
        if ([subType isEqualToString:@"unblockItemId"]) {
            return cityData.unblockItemId;
        }
        return [self stringByKey:subType];
    } else if ([type isEqualToString:@"string"]) {
        return subType;
    } else if ([type isEqualToString:@"reserved"]) {
        return [self reservedStringByKey:subType];
    } else if ([type isEqualToString:@"item"]) {
        NSString *itemId = [self reservedStringByKey:@"itemId"];
        if ([subType isEqualToString:@"itemName"]) {
            return getItemName(itemId);
        }
    }
    return type;
}

- (NSInteger)valueByType:(NSString *)type subType:(NSString *)subType
{
    NSInteger value = 0;
    if ([type isEqualToString:@"city"]) {
        GameCityData *cityData = [_cityDictionary objectForKey:_myguild.myTeam.currentCityId];
        if ([subType isEqualToString:@"percentage"]) {
            value = [[cityData.guildOccupation objectForKey:_myguildId] intValue];
        } else if ([subType isEqualToString:@"totalPercentage"]) {
            for (NSNumber *val in cityData.guildOccupation) {
                value += [val intValue];
            }
        } else if ([subType isEqualToString:@"guildNumber"]) {
            value = (int)[cityData.guildOccupation count];
        } else if ([subType isEqualToString:@"signUpMoney"]) {
            value = cityData.signUpUnitValue;
        } else if ([subType isEqualToString:@"militaryInvestMoney"]) {
            value = cityData.milltaryValue;
        } else if ([subType isEqualToString:@"commerceInvestMoney"]) {
            value = cityData.commerceValue;
        } else if ([subType isEqualToString:@"wage"]) {
            value = cityData.wage;
        } else if ([subType isEqualToString:@"nextSailorNumber"]) {
            value = cityData.nextSailorNumber;
        } else if ([subType isEqualToString:@"shipNumber"]) {
            value = [_myguild.myTeam getCarryShipListInCity:cityData.cityNo].count;
        } else if ([subType isEqualToString:@"sellItemNumber"]) {
            value = [[GameDataManager sharedGameData] itemListByCity:cityData.cityNo].count;
        }
    } else if ([type isEqualToString:@"guild"]) {
        if ([subType isEqualToString:@"item"]) {
            return [[_itemDictionary objectForKey:_myguildId].guildId isEqualToString:_myguildId];
        } else if ([subType isEqualToString:@"money"]) {
            value = _myguild.money;
        } else if ([subType isEqualToString:@"sellItemNumber"]) {
            value = [[GameDataManager sharedGameData] itemListByGuild:_myguild.guildId].count;
        }
    } else if ([type isEqualToString:@"ship"]) {
        if ([subType isEqualToString:@"number"]) {
            value = _myguild.myTeam.shipList.count;
        } else if ([subType isEqualToString:@"sailorNumber"]) {
            value = _myguild.myTeam.sailorNumbers;
        } else if ([subType isEqualToString:@"maxSailorNumber"]) {
            value = _myguild.myTeam.maxSailorNumbers;
        } else if ([subType isEqualToString:@"needSailorNumber"]) {
            value = _myguild.myTeam.needSailorNumber;
        }
    } else if ([type isEqualToString:@"cache"]) {
        value = [self intByKey:subType];
    } else if ([type isEqualToString:@"number"]) {
        value = [subType integerValue];
    } else if ([type isEqualToString:@"item"]) {
        NSString *itemId = [self reservedStringByKey:@"itemId"];
        if ([subType isEqualToString:@"money"]) {
            GameItemData *itemData = [[GameDataManager sharedGameData].itemDic objectForKey:itemId];
            value = itemData.itemData.price;
        }
    }
    return value;
}

@end
