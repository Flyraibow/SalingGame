//
//  CityData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameCityData.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "GameDataObserver.h"
#import "GameItemData.h"
#import "GameTaskData.h"
#import "TaskFactory.h"

static int const CityMaxCommerce = 10000;
static NSString* const GameCityNo = @"GameCityNo";
static NSString* const CityState = @"CityState";
static NSString* const CityBuildingList = @"CityBuildingList";
static NSString* const CitySaleList = @"CitySaleList";
static NSString* const CityShipsList = @"CityShipsList";
static NSString* const CityBoostList = @"CityBoostList";
static NSString* const CityCommerceValue = @"CityCommerceValue";
static NSString* const CityMilltaryValue = @"CityMilltaryValue";
static NSString* const CityTransactionRecord = @"CityTransactionRecord";
static NSString* const CityGuildOccupation = @"CityGuildOccupation";
static NSString* const CityMilltaryInvestRecord = @"CityMilltaryInvestRecord";
static NSString* const CityCommerceInvestRecord = @"CityCommerceInvestRecord";
static NSString* const CityCategoryPriceDict = @"CityCategoryPriceDict";
static NSString* const CityGoodsPriceDict = @"CityGoodsPriceDict";
static NSString* const CityUnlockGoodsDict = @"CityUnlockGoodsDict";
static NSString* const CityTaskGenerateDate = @"CityTaskGenerateDate";
static NSString* const CityTaskList = @"CityTaskList";

@implementation GameCityData
{
    NSMutableDictionary<NSString *, NSNumber *> *_guildOccupation;
    NSMutableArray<GameTaskData *> *_cityTasks;
    NSInteger _taskGeneratedDate;
}

@synthesize guildOccupation = _guildOccupation;

-(instancetype)initWithCityData:(CityData *)cityData
{
    self = [self init];
    if (self) {
        _cityNo = cityData.cityId;
        _buildingSet = [NSSet setWithArray:[cityData.buildings componentsSeparatedByString:@";"]];
        _shipsSet = [NSMutableSet setWithArray:[cityData.ships componentsSeparatedByString:@";"]];
        _commerceValue = cityData.commerce;
        _milltaryValue = cityData.milltary;
        
        _boostDict = [NSMutableDictionary new];
        NSArray *boostList = [cityData.goodsBoost componentsSeparatedByString:@";"];
        for (int i = 0; i < boostList.count; ++i) {
            NSString *boost = [boostList objectAtIndex:i];
            if (boost.length > 0) {
                NSArray *boostPair = [boost componentsSeparatedByString:@":"];
                [_boostDict setObject:boostPair[1] forKey:boostPair[0]];
            }
        }
        
        NSArray *goodsList = [cityData.goods componentsSeparatedByString:@";"];
        _goodsDict = [NSMutableDictionary new];
        for (int i = 0; i < goodsList.count; ++i) {
            int maxNum = [self getGoodsNum:goodsList[i]];
            [_goodsDict setObject:@(maxNum) forKey:goodsList[i]];
        }
        NSArray *unlockGoodsList = [cityData.unlockGoodsByItem componentsSeparatedByString:@";"];
        _unlockGoodsDict = [NSMutableDictionary new];
        for (int i = 0; i < unlockGoodsList.count; ++i) {
            NSString *unlockPairStr = unlockGoodsList[i];
            if (unlockPairStr.length > 0) {
                NSArray *unlockPair = [unlockPairStr componentsSeparatedByString:@"_"];
                [(NSMutableDictionary *)_unlockGoodsDict setObject:unlockPair[0] forKey:unlockPair[1]];
            }
        }
        _cityData = cityData;
        _transactionRecordDict = [NSMutableDictionary new];
        _guildOccupation = [NSMutableDictionary new];
        _commerceInvestRecord = 0;
        _milltaryInvestRecord = 0;
        _cityState = CityStateTypeNormal;
        _categoryPriceDict = [NSMutableDictionary new];
        _goodsPriceDict = [NSMutableDictionary new];
        _taskGeneratedDate = 0;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _cityNo = [aDecoder decodeObjectForKey:GameCityNo];
        _cityState = [aDecoder decodeIntegerForKey:CityState];
        _buildingSet = [aDecoder decodeObjectForKey:CityBuildingList];
        _goodsDict = [aDecoder decodeObjectForKey:CitySaleList];
        _shipsSet = [aDecoder decodeObjectForKey:CityShipsList];
        _boostDict = [aDecoder decodeObjectForKey:CityBoostList];
        _commerceValue = [aDecoder decodeIntForKey:CityCommerceValue];
        _milltaryValue = [aDecoder decodeIntForKey:CityMilltaryValue];
        _transactionRecordDict = [aDecoder decodeObjectForKey:CityTransactionRecord];
        _guildOccupation = [aDecoder decodeObjectForKey:CityGuildOccupation];
        _commerceInvestRecord = [aDecoder decodeIntegerForKey:CityCommerceInvestRecord];
        _milltaryInvestRecord = [aDecoder decodeIntegerForKey:CityMilltaryInvestRecord];
        _categoryPriceDict = [aDecoder decodeObjectForKey:CityCategoryPriceDict];
        _goodsPriceDict = [aDecoder decodeObjectForKey:CityGoodsPriceDict];
        _unlockGoodsDict = [aDecoder decodeObjectForKey:CityUnlockGoodsDict];
        _taskGeneratedDate = [aDecoder decodeIntegerForKey:CityTaskGenerateDate];
        _cityTasks = [aDecoder decodeObjectForKey:CityTaskList];
        _cityData = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cityNo forKey:GameCityNo];
    [aCoder encodeInteger:_cityState forKey:CityState];
    [aCoder encodeObject:_buildingSet forKey:CityBuildingList];
    [aCoder encodeObject:_goodsDict forKey:CitySaleList];
    [aCoder encodeObject:_shipsSet forKey:CityShipsList];
    [aCoder encodeObject:_boostDict forKey:CityBoostList];
    [aCoder encodeInt:_commerceValue forKey:CityCommerceValue];
    [aCoder encodeInt:_milltaryValue forKey:CityMilltaryValue];
    [aCoder encodeObject:_transactionRecordDict forKey:CityTransactionRecord];
    [aCoder encodeObject:_guildOccupation forKey:CityGuildOccupation];
    [aCoder encodeInteger:_commerceInvestRecord forKey:CityCommerceInvestRecord];
    [aCoder encodeInteger:_milltaryInvestRecord forKey:CityMilltaryInvestRecord];
    [aCoder encodeObject:_categoryPriceDict forKey:CityCategoryPriceDict];
    [aCoder encodeObject:_goodsPriceDict forKey:CityGoodsPriceDict];
    [aCoder encodeInteger:_taskGeneratedDate forKey:CityTaskGenerateDate];
    [aCoder encodeObject:_unlockGoodsDict forKey:CityUnlockGoodsDict];
    [aCoder encodeInteger:_cityTasks forKey:CityTaskList];
}

-(void)addBuilding:(NSString *)buildingNo
{
    _buildingSet = [_buildingSet setByAddingObject:buildingNo];
}

-(int)getGoodsNum:(NSString *)goodsId
{
    GoodsData *goodsData = [[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId];
    int maxNum = goodsData.maxNum * _commerceValue / CityMaxCommerce;
    if ([_boostDict objectForKey:goodsId] != nil) {
        maxNum *= (100 + [[_boostDict objectForKey:goodsId] intValue]) / 100.0;
    }
    return maxNum;
}

-(int)getGoodsLevel:(NSString *)goodsId
{
    GoodsData *goodsData = [[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId];
    int level;
    if (goodsData.needCommerce < _commerceValue) {
        level = 1;
    } else {
        level = 6 - _commerceValue * 4 / goodsData.needCommerce;
    }
    return level;
}

-(void)addGoods:(NSString *)goodsNo
{
    int maxNum = [self getGoodsNum:goodsNo];
    [_goodsDict setObject:@(maxNum) forKey:goodsNo];
}

-(void)modifyBoost:(NSString *)goodsNo value:(int)boostValue
{
    if (boostValue == 0) {
        [_boostDict removeObjectForKey:goodsNo];
    } else {
        [_boostDict setObject:@(boostValue) forKey:goodsNo];
    }
}

-(void)addShips:(NSString *)shipNo
{
    [_shipsSet addObject:shipNo];
}

-(BOOL)canSignUp:(NSString *)guildId
{
    int total = 0;
    for (NSString *guildNo in _guildOccupation) {
        if ([guildId isEqualToString:guildNo] == NO) {
            total += [[_guildOccupation objectForKey:guildNo] intValue];
        }
    }
    return total < 100 && _guildOccupation.count < 3;
}

-(int)getSalePriceForGoodsId:(NSString *)goodsId level:(int)level
{
    NSDictionary *dict = [DataManager sharedDataManager].getPriceDic;
    int basePrice = [[[dict objectForKey:goodsId] objectForKey:_cityNo] intValue];
    basePrice *= 1 + 0.1 * (5 - level);
    if ([_goodsDict objectForKey:goodsId] != nil) {
        basePrice /= 2.5;
    }
    NSNumber *categoryId = @([[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId].type);
    
    if ([_categoryPriceDict objectForKey: categoryId] != nil) {
        basePrice *= [[_categoryPriceDict objectForKey:categoryId] doubleValue];
    }
    if ([_goodsPriceDict objectForKey:goodsId] != nil) {
        basePrice *= [[_goodsPriceDict objectForKey:goodsId] doubleValue];
    }
    
    return basePrice;
}

-(int)getBuyPriceForGoodsId:(NSString *)goodsId
{
    if ([_goodsDict objectForKey:goodsId] == nil) {
        // 此城市不贩卖这种商品
        return 0;
    }
    return [self getBuyPriceForGoodsId:goodsId level:[self getGoodsLevel:goodsId]];
}

-(int)getBuyPriceForGoodsId:(NSString *)goodsId level:(int)level
{
    NSDictionary *dict = [DataManager sharedDataManager].getPriceDic;
    int basePrice = [[[dict objectForKey:goodsId] objectForKey:_cityNo] intValue];
    basePrice *= 1 + 0.1 * (level - 5);
    
    NSNumber *categoryId = @([[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId].type);
    
    if ([_categoryPriceDict objectForKey: categoryId] != nil) {
        basePrice *= [[_categoryPriceDict objectForKey:categoryId] doubleValue];
    }
    if ([_goodsPriceDict objectForKey:goodsId] != nil) {
        basePrice *= [[_goodsPriceDict objectForKey:goodsId] doubleValue];
    }
    return basePrice;
}

-(void)investByGuild:(NSString *)guildId investUnits:(int)units money:(int)money type:(InvestType)type
{
    if (type == InvestTypeCommerce) {
        _commerceInvestRecord += money;
        if ([_guildOccupation objectForKey:guildId] == nil) units = 0;
    } else if (type == InvestTypeMilitary) {
        _milltaryInvestRecord += money;
        if ([_guildOccupation objectForKey:guildId] == nil) units = 0;
    } else if (type == InvestTypeSignup) {
        _commerceInvestRecord += money;
        _milltaryInvestRecord += money;
    }
    [self addOccupationForGuild:guildId percent:units type:CityOccupationChangeTypeInvest];
}


-(int)getGoodsNumForGuild:(NSString *)guildId goodsId:(NSString *)goodsId
{
    int maxValue = [_goodsDict[goodsId] intValue] * _commerceValue / 10000;
    int guildNumber = maxValue * [_guildOccupation[guildId] intValue] / 100 + 1;
    guildNumber -= [[[_transactionRecordDict objectForKey:guildId] objectForKey:goodsId] intValue];
    
    
    return guildNumber;
}

-(void)addOccupationForGuild:(NSString *)guildId percent:(int)percent type:(CityOccupationChangeType)type
{
    if (type == CityOccupationChangeTypeInvest) {
        int sum = 0;
        for (NSString *guildNo in _guildOccupation) {
            sum += [[_guildOccupation objectForKey:guildNo] intValue];
        }
        if (sum + percent <= 100) {
            [self setOccupationForGuild:guildId percent:percent + [[_guildOccupation objectForKey:guildId] intValue]];
        } else {
            int val = 100 - sum;
            if (val > 0) {
                [self setOccupationForGuild:guildId percent:val + [[_guildOccupation objectForKey:guildId] intValue]];
            }
        }
    }
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_CITY_OCCUPATION data:_cityNo];
}

-(void)setOccupationForGuild:(NSString *)guildId percent:(int)percent
{
    if (percent <= 0) {
        [_guildOccupation removeObjectForKey:guildId];
    } else {
        [_guildOccupation setObject:@(percent) forKey:guildId];
    }
    int sum = 0;
    for (NSString *guildNo in _guildOccupation) {
        if (![guildId isEqualToString:guildNo]) {
            sum += [[_guildOccupation objectForKey:guildNo] intValue];
        }
    }
    if (sum > 100 - percent) {
        for (NSString *guildNo in _guildOccupation) {
            if (![guildId isEqualToString:guildNo]) {
                int val = [[_guildOccupation objectForKey:guildNo] intValue] * 1.0  * (100 - percent) / sum;
                if (val > 0)
                    [_guildOccupation setObject:@(val) forKey:guildNo];
                else {
                    [_guildOccupation removeObjectForKey:guildNo];
                }
            }
        }
    }
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_CITY_OCCUPATION data:_cityNo];
}

-(void)addTransactionRecord:(NSString *)guildId buyRecord:(NSDictionary *)buyRecords sellRecord:(NSDictionary *)sellRecords
{
    NSMutableDictionary *record = [_transactionRecordDict objectForKey:guildId];
    if (record == nil) {
        [_transactionRecordDict setObject:buyRecords forKey:guildId];
    } else {
        for (NSString *goodsId in buyRecords) {
            if ([record objectForKey:goodsId] == nil) {
                [record setObject:[buyRecords objectForKey:goodsId] forKey:goodsId];
            } else {
                int num = [[buyRecords objectForKey:goodsId] intValue];
                num += [[record objectForKey:goodsId] intValue];
                [record setObject:@(num) forKey:goodsId];
            }
        }
    }
    for (NSString *goodsId in buyRecords) {
        // 汇率浮动
        int price = [self getBuyPriceForGoodsId:goodsId level:[self getGoodsLevel:goodsId]] * [[buyRecords objectForKey:goodsId] intValue];
        double value = 1 + (price) / 100000.0;
        if ([_goodsPriceDict objectForKey:goodsId] != nil) {
            value *= [[_goodsPriceDict objectForKey:goodsId] doubleValue];
        }
        [_goodsPriceDict setObject:[@(value) stringValue] forKey:goodsId];
        
        NSNumber *categoryId = @([[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId].type);
        value = 1 + (price) / 500000.0;
        if ([_categoryPriceDict objectForKey:categoryId] != nil) {
            value *= [[_categoryPriceDict objectForKey:categoryId] doubleValue];
        }
        [_categoryPriceDict setObject:[@(value) stringValue] forKey:categoryId];
    }
    
    for (NSString *goodsId in sellRecords) {
        // 汇率浮动
        int price = [self getSalePriceForGoodsId:goodsId level:[self getGoodsLevel:goodsId]] * [[sellRecords objectForKey:goodsId] intValue];
        double value = 1 - (price) / 100000.0;
        if ([_goodsPriceDict objectForKey:goodsId] != nil) {
            value *= [[_goodsPriceDict objectForKey:goodsId] doubleValue];
        }
        [_goodsPriceDict setObject:[@(value) stringValue] forKey:goodsId];
        
        NSNumber *categoryId = @([[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId].type);
        value = 1 - (price) / 500000.0;
        if ([_categoryPriceDict objectForKey:categoryId] != nil) {
            value *= [[_categoryPriceDict objectForKey:categoryId] doubleValue];
        }
        [_categoryPriceDict setObject:[@(value) stringValue] forKey:categoryId];
    }
}

-(void)newMonth:(int)month
{
    _commerceValue += _commerceInvestRecord / 200;
    _commerceValue = MIN(_commerceValue, 10000);
    _milltaryValue += _milltaryInvestRecord / 200;
    _milltaryValue = MIN(_milltaryValue, 10000);
    
    if (_commerceInvestRecord > 0) {
        // 更新货物总数
        NSArray *goodsList = [_goodsDict allKeys];
        for (NSString *goodsId in goodsList) {
            int maxNum = [self getGoodsNum:goodsId];
            [_goodsDict setObject:@(maxNum) forKey:goodsId];
        }
        //添加解锁货物
        CityData *cityData = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo];
        NSArray *arr = [cityData.unlockGoodsByCommerce componentsSeparatedByString:@";"];
        for (NSString *str in arr) {
            if (str.length > 0) {
                NSString *goodsId = [str componentsSeparatedByString:@"_"][0];
                if ([_goodsDict objectForKey:goodsId] == nil) {
                    int value = [[str componentsSeparatedByString:@"_"][1] intValue];
                    if (_commerceValue >= value) {
                        int maxNum = [self getGoodsNum:goodsId];
                        [_goodsDict setObject:@(maxNum) forKey:goodsId];
                    }
                }
            }
        }
        // 解锁新的船只
        arr = [cityData.unlockShipsByCommerce componentsSeparatedByString:@";"];
        for (NSString *str in arr) {
            if (str.length > 0) {
                NSString *shipId = [str componentsSeparatedByString:@"_"][0];
                if (![_shipsSet containsObject:shipId]) {
                    int value = [[str componentsSeparatedByString:@"_"][1] intValue];
                    if (_commerceValue >= value) {
                        [_shipsSet addObject:shipId];
                    }
                }
            }
        }
        
    }
    _commerceInvestRecord = 0;
    _milltaryInvestRecord = 0;
    NSMutableSet *removeList = [NSMutableSet new];
    for (NSString *guildsNo in _transactionRecordDict) {
        NSMutableDictionary *goodsDic = [_transactionRecordDict objectForKey:guildsNo];
        for (NSString *goodsId in goodsDic) {
            GoodsData* goodsData = [[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId];
            GoodsCategoriesData *categoryData = [[[DataManager sharedDataManager] getGoodsCategoriesDic] getGoodsCategoriesById:[@(goodsData.type) stringValue]];
            if (categoryData.updateType == 1 || (categoryData.updateType == 2 && month % 2== 1) || (categoryData.updateType == 3 && month % 2 == 0) || (categoryData.updateType == 4 && month % 3 == 0)) {
                [removeList addObject:goodsId];
            }
        }
        for (NSString *goodsId in removeList) {
            [goodsDic removeObjectForKey:goodsId];
        }
    }
    
    //所有的价格浮动，降低50%的百分比，另外还有有些随机的波动性
    NSArray *goodsIdArray = [_goodsPriceDict allKeys];
    for (NSString *goodsId in goodsIdArray) {
        double value = [[_goodsPriceDict objectForKey:goodsId] doubleValue];
        value = (1 + value) / 2 + (arc4random() % 4 - 2.0) / 100.0;
        [_goodsPriceDict setObject:[@(value) stringValue] forKey:goodsId];
    }
    
    NSArray *categoryIdArray = [_categoryPriceDict allKeys];
    for (NSString *categoryId in categoryIdArray) {
        double value = [[_goodsPriceDict objectForKey:categoryId] doubleValue];
        value = (1 + value) / 2 + (arc4random() % 2 - 1.0) / 100.0;
        [_goodsPriceDict setObject:[@(value) stringValue] forKey:categoryId];
    }
    if ([_cityNo isEqualToString:[GameDataManager sharedGameData].myGuild.myTeam.currentCityId]) {
        [[GameDataManager sharedGameData] moveToCity:_cityNo];
    }
}

-(void)unlockGoodsByItem:(NSString *)itemId
{
    NSString *goodsId = [_unlockGoodsDict objectForKey:itemId];
    if (goodsId != nil) {
        [(NSMutableDictionary *)_unlockGoodsDict removeObjectForKey:itemId];
        int maxNum = [self getGoodsNum:goodsId];
        [_goodsDict setObject:@(maxNum) forKey:goodsId];
        if ([_cityNo isEqualToString:[GameDataManager sharedGameData].myGuild.myTeam.currentCityId]) {
            [[GameDataManager sharedGameData] moveToCity:_cityNo];
        }
    }
}

-(NSString *)unblockItemId
{
    MyGuild *myGuild = [GameDataManager sharedGameData].myGuild;
    for (NSString *itemId in self.unlockGoodsDict) {
        GameItemData * gameItemData = [[GameDataManager sharedGameData].itemDic objectForKey:itemId];
        if ([gameItemData.guildId isEqualToString:myGuild.guildId]) {
            return itemId;
        }
    }
    return nil;
}

-(int)signUpUnitValue
{
    return self.milltaryValue + self.commerceValue;
}

-(int)wage
{
    return 10 + self.commerceValue / 200 + arc4random() % 10;
}

-(int)nextSailorNumber
{
    return 5 + self.milltaryValue / 300 + arc4random() % 10;
}

-(NSInteger)percentage
{
    return [[self.guildOccupation objectForKey:[GameDataManager sharedGameData].myGuild.guildId] integerValue];
}

-(NSInteger)totalPercentage
{
    NSInteger value = 0;
    for (NSNumber *val in self.guildOccupation) {
        value += [val intValue];
    }
    return value;
}

-(NSInteger)guildNumber
{
    return [self.guildOccupation count];
}

-(NSInteger)shipNumber
{
    return [[GameDataManager sharedGameData].myGuild.myTeam getCarryShipListInCity:_cityNo].count;
}

-(NSInteger)sellItemNumber
{
    return [[GameDataManager sharedGameData] itemListByCity:_cityNo].count;
}

-(NSInteger)taskNumber
{
    return self.cityTasks.count;
}

-(NSArray *)cityTasks
{
    NSInteger date = [GameDataManager sharedGameData].date;
    if (_cityTasks == nil || date - _taskGeneratedDate > 30) {
        // generate new tasks, 30 天后强制刷新
        _taskGeneratedDate = date;
        _cityTasks = [[TaskFactory generateTask:3 forCity:self] mutableCopy];
    }
    return _cityTasks;
}

-(void)startTask:(GameTaskData *)taskData
{
    NSAssert([_cityTasks containsObject:taskData], @"Task data is invalid, %@", taskData);
    MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
    NSAssert(!myguild.taskData, @"Already had tasks");
    [myguild takeTask:taskData];
    [_cityTasks removeObject:taskData];
}

@end
