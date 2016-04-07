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
#import "OALSimpleAudio.h"

@implementation  GameDialogData
@end

@implementation GameData
{
    NSMutableSet *_timeUpdateSet;
    NSMutableSet *_occupationUpdateSet;
    NSMutableSet *_cityChangeSet;
}

static NSString* const GameDataDate = @"GameDate";
static NSString* const GameGuildDic= @"GameGuildDic";
static NSString* const GameMyGuild= @"GameMyGuild";
static NSString* const GameCityDic = @"GameCityDic";
static NSString* const GameLogicData = @"GameLogicData";
static NSString* const GameMuiscData = @"GameMusicData";

-(instancetype)init
{
    if (self = [super init]) {
        _dialogList = [NSMutableArray new];
        _cityDic = [NSMutableDictionary new];
        NSDictionary *cityDic= [[DataManager sharedDataManager].getCityDic getDictionary];
        for(NSString *key in cityDic)
        {
            GameCityData *cityData = [[GameCityData alloc] initWithCityData:[cityDic objectForKey:key]];
            [_cityDic setObject:cityData forKey:key];
        }
        _npcDic = [NSMutableDictionary new];
        NSDictionary *npcDic = [[DataManager sharedDataManager].getNpcDic getDictionary];
        for (NSString *npcId in npcDic) {
            GameNPCData *gameNPCData = [[GameNPCData alloc] initWithNpcId:npcId];
            [_npcDic setObject:gameNPCData forKey:npcId];
        }
    }
    return self;
}

-(void)initGuildData
{
    _guildDic = [NSMutableDictionary new];
    NSDictionary *guildDic = [[DataManager sharedDataManager].getGuildDic getDictionary];
    for (id key in guildDic) {
        GameGuildData *guildData = [[GameGuildData alloc] initWithGuildData:[guildDic objectForKey:key]];
        [_guildDic setObject:guildData forKey:key];
    }
    _timeUpdateSet = [NSMutableSet new];
    _occupationUpdateSet = [NSMutableSet new];
    _cityChangeSet = [NSMutableSet new];
    // initialize the logic Data
    _logicData = [NSMutableDictionary new];
    NSDictionary *logicDataType = [[[DataManager sharedDataManager] getLogicDataDic] getDictionary];
    for (NSString *logicId in logicDataType) {
        [_logicData setObject:@"0" forKey:logicId];
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
            if (goodsStr.length > 0) {
                NSString *goodsId = [goodsStr componentsSeparatedByString:@"_"][0];
                int goodsLevel = [[goodsStr componentsSeparatedByString:@"_"][1] intValue];
                GameShipGoodsData *goodsData = [[GameShipGoodsData alloc] initWithGoodsId:goodsId price:0 level:goodsLevel];
                if (index < ship.capacity)
                {
                    [ship.goodsList replaceObjectAtIndex:index++ withObject:goodsData];
                }
            }
        }
        [self.myGuild.myTeam.shipList addObject:ship];
    } else if ([logicName isEqualToString:@"npc"]) {
        if ([parameter2 isEqualToString:@"1"]) {
            // 角色加入
            [self.myGuild.myTeam addNpcId:parameter3];
            
        } else if ([parameter2 isEqualToString:@"2"]) {
            // 角色离开队伍
            [self.myGuild.myTeam addNpcId:parameter3];
        }
    }
}


-(void)setLogicDataWithLogicId:(NSString *)logicId value:(NSString *)logicValue changeValueType:(ChangeValueType)type
{
    if ([logicId isEqualToString:@"money"]) {
        if (type == ChangeValueTypeEqual) {
            [self.myGuild setMoney:[logicValue integerValue]];
        } else if (type == ChangeValueTypeAdd) {
            [self.myGuild gainMoney:[logicValue integerValue]];
        } else if (type == ChangeValueTypeMinus) {
            [self.myGuild gainMoney:-[logicValue integerValue]];
        } else if (type == ChangeValueTypeMultiply) {
            [self.myGuild gainMoney:self.myGuild.money * ([logicValue doubleValue] - 1)];
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
        [_logicData setObject:newValue forKey:logicId];
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        NSInteger date = [aDecoder decodeIntegerForKey: GameDataDate];
        _day = date % 100;
        date /= 100;
        _month = date % 100;
        date /= 100;
        _year = date % 1000;
        _guildDic = [aDecoder decodeObjectForKey:GameGuildDic];
        _myGuild = [aDecoder decodeObjectForKey:GameMyGuild];
        _cityDic = [aDecoder decodeObjectForKey:GameCityDic];
        _logicData = [aDecoder decodeObjectForKey:GameLogicData];
        self.currentMusic = [aDecoder decodeObjectForKey:GameMuiscData];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSInteger date = _day + _month * 100 + _year * 10000;
    [aCoder encodeInteger:date forKey:GameDataDate];
    [aCoder encodeObject:_guildDic forKey:GameGuildDic];
    [aCoder encodeObject:_myGuild forKey:GameMyGuild];
    [aCoder encodeObject:_cityDic forKey:GameCityDic];
    [aCoder encodeObject:_logicData forKey:GameLogicData];
    [aCoder encodeObject:_currentMusic forKey:GameMuiscData];
}

-(void)addTimeUpdateClass:(id<DateUpdateProtocol>)target
{
    [_timeUpdateSet addObject:target];
}

-(void)removeTimeUpdateClass:(id)target
{
    [_timeUpdateSet removeObject:target];
}

-(void)addOccupationUpdateClass:(id<OccupationUpdateProtocol>)target
{
    [_occupationUpdateSet addObject:target];
}

-(void)removeOccupationUpdateClass:(id)target
{
    [_occupationUpdateSet removeObject:target];
}

-(void)sendOccupationUpdateInfo:(NSString *)cityNo data:(NSMutableDictionary *)dict
{
    for (id<OccupationUpdateProtocol> target in _occupationUpdateSet) {
        [target occupationUpdateCityNo:cityNo data:dict];
    }
}

-(void)addCityChangeClass:(id<CityChangeProtocol>)target
{
    [_cityChangeSet addObject:target];
}

-(void)removeCityChangeClass:(id)target
{
    [_cityChangeSet removeObject:target];
}

-(void)setYear:(int)year month:(int)month day:(int)day
{
    _day = day;
    _month = month;
    _year = year;
}

-(void)spendOneDay
{
    _day++;
    if (_day == 29) {
        if (_month == 2 && _year % 4 != 0) {
            [self passMonth];
        }
    } else if(_day == 30) {
        if(_month == 2 && _year % 4 == 0) {
            [self passMonth];
        }
    } else if(_day == 31) {
        if (_month == 4 || _month == 6 || _month == 9 || _month == 11) {
            [self passMonth];
        }
    } else if(_day == 32) {
        [self passMonth];
    }
    for (id<DateUpdateProtocol> target in _timeUpdateSet) {
        [target updateDate];
    }
}

-(void)passMonth
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
                        [guildData gainMoney:money];
                    }
                }
            }
        }
    }
    if (contractMoney > 0) {
        [[GameDataManager sharedGameData].myGuild gainMoney:contractMoney];
        // notify
        GameDialogData *dialogData = [GameDialogData new];
        dialogData.portrait = @"0";
        dialogData.npcName = @"";
        NSString *text = [NSString stringWithFormat:getLocalString(@"get_contract_money"), contractMoney];
        dialogData.text = text;
        [_dialogList addObject:dialogData];
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
    for (id<CityChangeProtocol> target in _cityChangeSet) {
        [target changeCity:cityNo];
    }
}

-(void)setCurrentMusic:(NSString *)currentMusic
{
    if (![_currentMusic isEqualToString:currentMusic]) {
        _currentMusic = [currentMusic copy];
        
        [[OALSimpleAudio sharedInstance] playBg:currentMusic loop:YES];
    }
}

@end
