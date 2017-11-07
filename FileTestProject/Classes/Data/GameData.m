//
//  GameData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameData.h"
#import "LocalString.h"
#import "DataManager.h"
#import "GameCityData.h"
#import "GameShipGoodsData.h"
#import "GameDataManager.h"
#import "GameNPCData.h"
#import "GameItemData.h"
#import "OALSimpleAudio.h"
#import "GameValueManager.h"
#import "GameDataObserver.h"

@implementation  GameDialogData
@end

@implementation GameData
{
    NSUInteger _shipIdIndex;
}

static NSString* const GameDataDate = @"GameDate";
static NSString* const GameGuildDic= @"GameGuildDic";
static NSString* const GameMyGuild= @"GameMyGuild";
static NSString* const GameCityDic = @"GameCityDic";
static NSString* const GameLogicData = @"GameLogicData";
static NSString* const GameStoryLockData = @"GameStoryLockData";
static NSString* const GameMuiscData = @"GameMusicData";
static NSString* const GameItemDataState = @"GameItemDataState";
static NSString* const GameNPCDic = @"GameNPCDic";
static NSString* const GameShipDic = @"GameShipDic";
static NSString* const GameShipMaxIndex = @"GameShipMaxIndex";

-(instancetype)init
{
    if (self = [super init]) {
        _shipIdIndex = 0;
        [self commonInit];
        NSDictionary *cityDic = [[DataManager sharedDataManager].getCityDic getDictionary];
        for(NSString *key in cityDic)
        {
            GameCityData *cityData = [[GameCityData alloc] initWithCityData:[cityDic objectForKey:key]];
            [(NSMutableDictionary *)_cityDic setObject:cityData forKey:key];
        }
        _npcDic = [NSMutableDictionary new];
        NSDictionary *npcDic = [[DataManager sharedDataManager].getNpcDic getDictionary];
        for (NSString *npcId in npcDic) {
            GameNPCData *gameNPCData = [[GameNPCData alloc] initWithNpcId:npcId];
            [(NSMutableDictionary *)_npcDic setObject:gameNPCData forKey:npcId];
        }
        NSDictionary *itemDic = [[DataManager sharedDataManager].getItemDic getDictionary];
        for (NSString *itemId in itemDic) {
            GameItemData *gameItemData = [[GameItemData alloc] initWithItemData:itemDic[itemId]];
            [(NSMutableDictionary *)_itemDic setObject:gameItemData forKey:itemId];
        }
    }
    return self;
}

-(void)commonInit
{
    _dialogList = [NSMutableArray new];
    _cityDic = [NSMutableDictionary new];
    _itemDic = [NSMutableDictionary new];
    _shipDic = [NSMutableDictionary new];
}

-(void)initGuildData
{
    _guildDic = [NSMutableDictionary new];
    NSDictionary *guildDic = [[DataManager sharedDataManager].getGuildDic getDictionary];
    for (id key in guildDic) {
        GameGuildData *guildData = [[GameGuildData alloc] initWithGuildData:[guildDic objectForKey:key]];
        [(NSMutableDictionary *)_guildDic setObject:guildData forKey:key];
    }
    // initialize the logic Data
    _logicData = [NSMutableDictionary new];
    NSDictionary *logicDataType = [[[DataManager sharedDataManager] getLogicDataDic] getDictionary];
    for (NSString *logicId in logicDataType) {
        [(NSMutableDictionary *)_logicData setObject:@"0" forKey:logicId];
    }
    _storyLockData = [NSMutableDictionary new];
    NSDictionary *storyTriggerDic = [[[DataManager sharedDataManager] getStoryTriggerDic] getDictionary];
    for (NSString *storyId in storyTriggerDic) {
        StoryTriggerData *storyTriggerData = [storyTriggerDic objectForKey:storyId];
        [(NSMutableDictionary *)_storyLockData setObject:@(storyTriggerData.locked == 1) forKey:storyId];
    }
}

-(void)initMyGuildWithGameGuildData:(GameGuildData *)guildData
{
    if (guildData != nil) {
        _myGuild = [[MyGuild alloc] initWithGameGuildData:guildData];
    } else {
        _myGuild = [MyGuild new];
    }
}

-(NSString *)getLogicData:(NSString *)logicId
{
    if ([logicId isEqualToString:@"money"]) {
        return [@(self.myGuild.money) stringValue];
    } else if([logicId isEqualToString:@"myGuildId"]) {
        return self.myGuild.guildId;
    } else if([logicId isEqualToString:@"date"]) {
        return [self getDateStringWithYear:NO];
    } else if([logicId isEqualToString:@"myLeaderId"]) {
        return self.myGuild.leaderId;
    } else if([logicId isEqualToString:@"dateWithYear"]) {
        return [self getDateStringWithYear:YES];
    } else if([logicId isEqualToString:@"day"]) {
        return [@(_day) stringValue];
    } else if([logicId isEqualToString:@"month"]) {
        return [@(_month) stringValue];
    } else if([logicId isEqualToString:@"year"]) {
        return [@(_year) stringValue];
    } else {
        return [_logicData objectForKey:logicId];
    }
}

-(void)setSpecialLogical:(NSString *)logicName parameter2:(NSString *)parameter2 parameter3:(NSString *)parameter3 parameter4:(NSString *)parameter4
{
    if([logicName isEqualToString:@"ship"]) {
        NSString *shipNo = parameter2;
        
        GameShipData *ship = [[GameShipData alloc] initWithShipData:[[[DataManager sharedDataManager] getShipDic] getShipById:shipNo]];
        if ([parameter3 isEqualToString:@"0"] == NO) {
            ship.shipName = getLocalString(parameter3);
        }
        NSArray *goodsList = [parameter4 componentsSeparatedByString:@";"];
        int index = 0;
        for (int i = 0; i < goodsList.count; ++i) {
            NSString *goodsStr = [goodsList objectAtIndex:i];
            if (goodsStr.length > 1) {
                NSString *goodsId = [goodsStr componentsSeparatedByString:@"_"][0];
                int goodsLevel = [[goodsStr componentsSeparatedByString:@"_"][1] intValue];
                if (index < ship.capacity)
                {
                    GameShipGoodsData *goodsData = ship.goodsList[index++];
                    [goodsData setGoodsId:goodsId price:0 level:goodsLevel];
                }
            }
        }
        [self.myGuild.myTeam getShip:ship cityId:nil];
    } else if ([logicName isEqualToString:@"npc"]) {
        if ([parameter2 isEqualToString:@"1"]) {
            // 角色加入
            [self.myGuild.myTeam addNpcId:parameter3];
            
        } else if ([parameter2 isEqualToString:@"2"]) {
            // 角色离开队伍
            [self.myGuild.myTeam addNpcId:parameter3];
        }
    } else if ([logicName isEqualToString:@"money"]) {
        if ([parameter2 intValue] == 1) {
            self.myGuild.money +=[parameter3 intValue];
        } else if ([parameter2 intValue] == 2) {
            [self.myGuild spendMoney:-[parameter3 intValue]];
        } else if ([parameter2 intValue] == 3) {
            [self.myGuild setMoney:[parameter3 intValue]];
        }
    }
}


-(void)setLogicDataWithLogicId:(NSString *)logicId value:(NSString *)logicValue changeValueType:(ChangeValueType)type
{
    if ([logicId isEqualToString:@"money"]) {
        if (type == ChangeValueTypeEqual) {
            [self.myGuild setMoney:[logicValue integerValue]];
        } else if (type == ChangeValueTypeAdd) {
            self.myGuild.money += [logicValue integerValue];
        } else if (type == ChangeValueTypeMinus) {
            [self.myGuild spendMoney:[logicValue integerValue]];
        } else if (type == ChangeValueTypeMultiply) {
            self.myGuild.money += self.myGuild.money * ([logicValue doubleValue] - 1);
        } else if (type == ChangeValueTypeDivide) {
            [self.myGuild setMoney:self.myGuild.money / [logicValue doubleValue]];
        }
    } else if([logicId isEqualToString:@"date"]) {
        if (type == ChangeValueTypeAdd) {
            // TODO: jump out of the story temporarily
//            int days = [logicValue intValue];
//            [self spendOneDay];
        } else {
            //don't support that
        }
    } else {
        NSString *originalValue = [_logicData objectForKey:logicId];
        NSString *newValue = originalValue;
        if (type == ChangeValueTypeEqual) {
            newValue = logicValue;
        } else if (type == ChangeValueTypeAdd) {
            newValue = [@([logicValue integerValue] + [originalValue integerValue]) stringValue];
        } else if (type == ChangeValueTypeMinus) {
            newValue = [@(-[logicValue integerValue] + [originalValue integerValue]) stringValue];
        } else if (type == ChangeValueTypeMultiply) {
            newValue = [@([logicValue integerValue] * [originalValue integerValue]) stringValue];
        } else if (type == ChangeValueTypeDivide) {
            newValue = [@([originalValue integerValue] / [logicValue integerValue]) stringValue];
        } else {
            // Expression : TODO
        }
        [(NSMutableDictionary *)_logicData setObject:newValue forKey:logicId];
    }
}

-(void)removeLogicDataWithLogicId:(NSString *)logicId
{
    [(NSMutableDictionary *)_logicData removeObjectForKey:logicId];
}

-(void)setStoryLockWithStoryId:(NSString *)storyId locked:(BOOL)locked
{
    [(NSMutableDictionary *)_storyLockData setObject:@(locked) forKey:storyId];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self commonInit];
        _date = [aDecoder decodeIntegerForKey: GameDataDate];
        NSInteger date = _date;
        _day = date % 100;
        date /= 100;
        _month = date % 100;
        date /= 100;
        _year = (int)date;
        _shipIdIndex = [aDecoder decodeIntegerForKey:GameShipMaxIndex];
        _shipDic = [aDecoder decodeObjectForKey:GameShipDic];
        _npcDic = [aDecoder decodeObjectForKey:GameNPCDic];
        _guildDic = [aDecoder decodeObjectForKey:GameGuildDic];
        _myGuild = [aDecoder decodeObjectForKey:GameMyGuild];
        _cityDic = [aDecoder decodeObjectForKey:GameCityDic];
        _logicData = [aDecoder decodeObjectForKey:GameLogicData];
        _itemDic = [aDecoder decodeObjectForKey:GameItemDataState];
        _storyLockData = [aDecoder decodeObjectForKey:GameStoryLockData];
        NSDictionary *itemDic = [[DataManager sharedDataManager].getItemDic getDictionary];
        for (NSString *itemNo in _itemDic) {
            GameItemData *gameItemData = _itemDic[itemNo];
            gameItemData.itemData = itemDic[itemNo];
        }
        self.currentMusic = [aDecoder decodeObjectForKey:GameMuiscData];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSInteger date = _day + _month * 100 + _year * 10000;
    NSAssert(date == _date, @"check time got wrong");
    [aCoder encodeInteger:date forKey:GameDataDate];
    [aCoder encodeObject:_guildDic forKey:GameGuildDic];
    [aCoder encodeObject:_myGuild forKey:GameMyGuild];
    [aCoder encodeObject:_cityDic forKey:GameCityDic];
    [aCoder encodeObject:_logicData forKey:GameLogicData];
    [aCoder encodeObject:_currentMusic forKey:GameMuiscData];
    [aCoder encodeObject:_itemDic forKey:GameItemDataState];
    [aCoder encodeObject:_storyLockData forKey:GameStoryLockData];
    [aCoder encodeObject:_npcDic forKey:GameNPCDic];
    [aCoder encodeObject:_shipDic forKey:GameShipDic];
    [aCoder encodeInteger:_shipIdIndex forKey:GameShipMaxIndex];
}

-(void)setYear:(int)year month:(int)month day:(int)day
{
    _day = day;
    _month = month;
    _year = year;
    _date = _day + _month * 100 + _year * 10000;
}

-(void)spendOneDay
{
    _date++;
    _day++;
    if (_day == 29) {
        if (_month == 2 && _year % 4 != 0) {
            [self _passMonth];
        }
    } else if(_day == 30) {
        if(_month == 2 && _year % 4 == 0) {
            [self _passMonth];
        }
    } else if(_day == 31) {
        if (_month == 4 || _month == 6 || _month == 9 || _month == 11) {
            [self _passMonth];
        }
    } else if(_day == 32) {
        [self _passMonth];
    }
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_DATE data:nil];
}

-(void)_passMonth
{
    _day = 1;
    _month++;
    if (_month == 13) {
        _month = 1;
        _year++;
    }
    //所有城市的商品更新，投资值更新，产生新的商品
    //TODO: 结算每个月的福利，包括独享契约
    NSInteger contractMoney = 0;
    NSString *myguildId = [GameDataManager sharedGameData].myGuild.guildId;
    for (NSString *cityNo in _cityDic) {
        GameCityData *cityData = [_cityDic objectForKey:cityNo];
        [cityData newMonth:_month];
        if ([cityData.guildOccupation count] == 1) {
            for (NSString *guildId in cityData.guildOccupation) {
                if ([[cityData.guildOccupation objectForKey:guildId] intValue] >= 100) {
                    // 发钱, 如果是主角，额外发通知
                    GameGuildData *guildData = [[GameDataManager sharedGameData].guildDic objectForKey:guildId];
                    int money = cityData.commerceValue / 10;
                    if ([guildId isEqualToString:myguildId]) {
                        contractMoney += money;
                    } else {
                        guildData.money += money;
                    }
                }
            }
        }
    }
    if (contractMoney > 0) {
        [GameDataManager sharedGameData].myGuild.money += contractMoney;
        // notify
        GameDialogData *dialogData = [GameDialogData new];
        dialogData.portrait = @"0";
        dialogData.npcName = @"";
        NSString *text = [NSString stringWithFormat:getLocalString(@"get_contract_money"), contractMoney];
        dialogData.text = text;
        [(NSMutableArray *)_dialogList addObject:dialogData];
    }
}

-(NSString *)getDateStringWithYear:(BOOL)wy
{
    if(wy)
        return [NSString stringWithFormat:getLocalString(@"lab_date_wy"), _year, _month, _day];
    else {
        return [NSString stringWithFormat:getLocalString(@"lab_date"), _month, _day];
    }
}

-(void)moveToCity:(NSString *)cityNo
{
    _myGuild.myTeam.currentCityId = cityNo;
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_CITY data:cityNo];
}

-(void)setCurrentMusic:(NSString *)currentMusic
{
    if (![_currentMusic isEqualToString:currentMusic]) {
        _currentMusic = currentMusic;
        
        [[OALSimpleAudio sharedInstance] playBg:currentMusic loop:YES];
    }
}


-(NSArray *)itemListByCity:(NSString *)cityId
{
    NSMutableArray *itemList = [NSMutableArray new];
    for (NSString *itemId in _itemDic) {
        GameItemData *gameItemData = [_itemDic objectForKey:itemId];
        if ([gameItemData.cityNo isEqualToString:cityId]) {
            [itemList addObject:gameItemData];
        }
    }
    return itemList;
}

-(NSArray *)itemListByGuild:(NSString *)guildId
{
    NSMutableArray *itemList = [NSMutableArray new];
    for (NSString *itemId in _itemDic) {
        GameItemData *gameItemData = [_itemDic objectForKey:itemId];
        if ([gameItemData.guildId isEqualToString:guildId]) {
            [itemList addObject:gameItemData];
        }
    }
    return itemList;
}

-(BOOL)containsItem:(NSString *)itemId guildId:(NSString *)guildId
{
    GameItemData *gameItemData = [_itemDic objectForKey:itemId];
    return [gameItemData.guildId isEqualToString:guildId];
}

-(void)registerGameShipData:(GameShipData *)gameShipData
{
    if (gameShipData.shipId && [_shipDic objectForKey:gameShipData.shipId]) {
        return;
    }
    gameShipData.shipId = [@(_shipIdIndex++) stringValue];
    [_shipDic setObject:gameShipData forKey:gameShipData.shipId];
}

-(void)dataChangeWithTerm:(NSString *)term
{
    NSArray *array = [term componentsSeparatedByString:@";"];
    if ([array[0] isEqualToString:@"money"]) {
        if ([array[1] isEqualToString:@"-"]) {
            self.myGuild.money -= [[GameValueManager sharedValueManager] getNumberByTerm:array[2]];
        } else if ([array[1] isEqualToString:@"+"]) {
            self.myGuild.money += [[GameValueManager sharedValueManager] getNumberByTerm:array[2]];
        }
    } else if ([array[0] isEqualToString:@"item"]) {
        NSString *itemId = [[GameValueManager sharedValueManager] getStringByTerm:array[2]];
        GameItemData *itemData = [self.itemDic objectForKey:itemId];
        if ([array[1] isEqualToString:@"sell"]) {
            [itemData sellToCityNo:self.myGuild.myTeam.currentCityId];
        } else if ([array[1] isEqualToString:@"get"]) {
            [itemData boughtByGuildNo:self.myGuild.guildId];
        } else if ([array[1] isEqualToString:@"use"]) {
            [itemData isUsed];
        }
    } else if ([array[0] isEqualToString:@"city"]) {
        GameCityData *cityData = [self.cityDic objectForKey:_myGuild.myTeam.currentCityId];
        if ([array[1] isEqualToString:@"unblockItem"]) {
            [cityData unlockGoodsByItem:[[GameValueManager sharedValueManager] getStringByTerm:array[2]]];
        }
    } else if ([array[0] isEqualToString:@"role"]) {
        GameNPCData *npcData = [GameValueManager sharedValueManager].reservedNPCData;
        if ([array[1] isEqualToString:@"equip"]) {
            NSString *itemId = [[GameValueManager sharedValueManager] getStringByTerm:array[2]];
            GameItemData *itemData = [self.itemDic objectForKey:itemId];
            [npcData equip:itemData];
        } else if ([array[1] isEqualToString:@"unequip"]) {
            NSString *itemId = [[GameValueManager sharedValueManager] getStringByTerm:array[2]];
            GameItemData *itemData = [self.itemDic objectForKey:itemId];
            [npcData unequip:itemData];
        }
    } else if ([array[0] isEqualToString:@"ship"]) {
        GameShipData *shipData = [GameValueManager sharedValueManager].reservedShipData;
        if ([array[1] isEqualToString:@"equip"]) {
            NSString *itemId = [[GameValueManager sharedValueManager] getStringByTerm:array[2]];
            GameItemData *itemData = [self.itemDic objectForKey:itemId];
            [shipData equip:itemData];
        } else if ([array[1] isEqualToString:@"unequip"]) {
            NSString *itemId = [[GameValueManager sharedValueManager] getStringByTerm:array[2]];
            GameItemData *itemData = [self.itemDic objectForKey:itemId];
            [shipData unequip:itemData];
        }
    } else if ([array[0] isEqualToString:@"team"]) {
        GameTeamData *teamData = self.myGuild.myTeam;
        if ([array[1] isEqualToString:@"fillUp"]) {
            [teamData fillFood:[[GameValueManager sharedValueManager] getNumberByTerm:array[2]]];
        }
    } else if ([array[0] isEqualToString:@"guild"]) {
        if ([array[1] isEqualToString:@"forsakeTask"]) {
            [self.myGuild forsakeTask];
        }
    }
}


-(GameCityData *)randomCityFromCity:(GameCityData *)cityData
                          condition:(CitySearchCondition)condition
{
    NSMutableArray<GameCityData *> *array = [NSMutableArray new];
    for (NSString *cityId in _cityDic) {
        if ([cityId isEqualToString:cityData.cityNo]) {
            continue;
        }
        GameCityData *city = [_cityDic objectForKey:cityId];
        if ((condition & CityNear) && city.cityData.seaArea != cityData.cityData.seaArea) {
            continue;
        }
        if ((condition & CityFaraway) && city.cityData.seaArea == cityData.cityData.seaArea) {
            continue;
        }
        if ((condition & CityCapital) && city.cityData.cityScale != CityScaleTypeBigCity) {
            continue;
        }
        if (condition & CityDifferentGoods) {
            BOOL differentFood = NO;
            for (NSString *goodsId in city.goodsDict) {
                if (goodsId != nil && [cityData.goodsDict objectForKey:goodsId] == nil) {
                    differentFood = YES;
                    break;
                }
            }
            if (!differentFood) {
                continue;
            }
        }
        if ((condition & CitySameOwner)) {
            // TODO:
        }
        [array addObject:city];
    }
    if (array.count > 0) {
        return array[arc4random() % array.count];
    }
    return nil;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ Level : %d", getNpcFullName(_myGuild.leaderId), [_myGuild leaderData].level];
}

@end
