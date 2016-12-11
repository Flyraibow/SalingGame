//
//  GameTeamData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameTeamData.h"
#import "GameShipData.h"
#import "GameDataManager.h"
#import "DataManager.h"
#import "GameNPCData.h"
#import "GameItemData.h"

static NSString* const GameTeamMoney = @"GameTeamMoney";
static NSString* const GameTeamId = @"GameTeamId";
static NSString* const GameTeamLeader = @"GameTeamLeader";
static NSString* const GameTeamShipList = @"GameTeamShipList";
static NSString* const GameTeamBelongGuildId = @"GameTeamBelongGuildId";
static NSString* const GameTeamCurrentCity = @"GameTeamCurrentCity";
static NSString* const GameTeamNPCData = @"GameTeamNPCData";
static NSString* const GameTeamCarryShipList = @"GameTeamCarryShipList";

static NSInteger const FoodCapacityPerUnit = 100;

@interface GameTeamData()

@property (nonatomic, weak) NSMutableDictionary *shipDic;

@end

@implementation GameTeamData
{
    NSMutableArray<NSString *> *_shipList;
    NSMutableArray<NSString *> *_carryShipList;
}

@synthesize shipList = _shipList;
@synthesize carryShipList = _carryShipList;

-(NSMutableDictionary *)shipDic
{
    if (!_shipDic) {
        _shipDic = [GameDataManager sharedGameData].shipDic;
    }
    return _shipDic;
}

-(instancetype)initWithTeamData:(TeamData *)teamData guildId:(NSString *)guildId
{
    if (self = [self init]) {
        _shipList = [NSMutableArray new];
        _teamId = teamData.teamId;
        _leaderId = teamData.leaderId;
        _belongToGuildId = guildId;
        NSArray *shipArray = [teamData.shiplist componentsSeparatedByString:@";"];
        for (int i = 0; i < shipArray.count; ++i) {
            NSString *shipTypeId = [shipArray objectAtIndex:i];
            if (shipTypeId.length > 0) {
                GameShipData *shipData = [[GameShipData alloc] initWithShipData:[[DataManager sharedDataManager].getShipDic getShipById:shipTypeId]];
                [self getShip:shipData cityId:nil];
            }
        }
        NSMutableArray *npcList = [NSMutableArray new];
        NSDictionary *npcDic = [GameDataManager sharedGameData].npcDic;
        GameNPCData *leaderData = [npcDic objectForKey:_leaderId];
        leaderData.isCaptain = YES;
        leaderData.job = NPCJobTypeCaptain;
        [npcList addObject:leaderData];
        NSArray *npcStrList = [teamData.npcList componentsSeparatedByString:@";"];
        for (NSString *npcId in npcStrList) {
            if (npcId.length > 0) {
                [npcList addObject:[npcDic objectForKey:npcId]];
            }
        }
        _carryShipList = [NSMutableArray new];
        _npcList = npcList;
        _currentCityId = teamData.startCity;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _teamId = [aDecoder decodeObjectForKey:GameTeamId];
        _teamMoney = [aDecoder decodeIntegerForKey: GameTeamMoney];
        _leaderId = [aDecoder decodeObjectForKey:GameTeamLeader];
        _shipList = [aDecoder decodeObjectForKey:GameTeamShipList];
        _belongToGuildId = [aDecoder decodeObjectForKey:GameTeamBelongGuildId];
        _currentCityId = [aDecoder decodeObjectForKey:GameTeamCurrentCity];
        _carryShipList = [aDecoder decodeObjectForKey:GameTeamCarryShipList];
        NSMutableArray<NSString *> *npcList = [aDecoder decodeObjectForKey:GameTeamNPCData];
        _npcList = [NSMutableArray new];
        NSDictionary *npcDic = [GameDataManager sharedGameData].npcDic;
        for (int i = 0; i < npcList.count; ++i) {
            [(NSMutableArray *)_npcList addObject:npcDic[npcList[i]]];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_teamMoney forKey:GameTeamMoney];
    [aCoder encodeObject:_teamId forKey:GameTeamId];
    [aCoder encodeObject:_leaderId forKey:GameTeamLeader];
    [aCoder encodeObject:_shipList forKey:GameTeamShipList];
    [aCoder encodeObject:_belongToGuildId forKey:GameTeamBelongGuildId];
    [aCoder encodeObject:_currentCityId forKey:GameTeamCurrentCity];
    [aCoder encodeObject:_carryShipList forKey:GameTeamCarryShipList];
    NSMutableArray<NSString *> *npcList = [NSMutableArray new];
    for (int i = 0; i < _npcList.count; ++i) {
        GameNPCData *npcData = _npcList[i];
        [npcList addObject:npcData.npcId];
    }
    [aCoder encodeObject:npcList forKey:GameTeamNPCData];
}

-(NSInteger)needsFoodCapacity
{
    CGFloat foodCapacity = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        foodCapacity += (shipData.maxFoodCapacity - shipData.foodCapacity) * FoodCapacityPerUnit;
    }
    return foodCapacity;
}

-(void)fillFood:(NSInteger)food
{
    CGFloat foodUnit = 1.0 * food / FoodCapacityPerUnit;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        if (foodUnit > 0) {
            foodUnit -= shipData.maxFoodCapacity - shipData.foodCapacity;
            shipData.foodCapacity = shipData.maxFoodCapacity;
            if (foodUnit< 0) {
                shipData.foodCapacity += foodUnit;
                return;
            }
        } else {
            return;
        }
    }
}

-(int)sailorNumber
{
    int sailorNumbers = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        sailorNumbers += shipData.curSailorNum;
    }
    return sailorNumbers;
}

- (int)maxSailorNumber
{
    int maxSailorNumbers = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        maxSailorNumbers += shipData.maxSailorNum;
    }
    return maxSailorNumbers;
}

- (int)needSailorNumber
{
    int maxSailorNumbers = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        maxSailorNumbers += shipData.minSailorNum;
    }
    return maxSailorNumbers;
}

// 需要的水手人数，如果水手够用，则返回正数，表示距离最大值的数值
// 如果水手不足必要，则返回负数，其绝对值表示，距离必要水手的人数
-(int)needSailorNumbersWithNewHiring:(int)newSailorsNum
{
    int sailorNumbers = newSailorsNum;
    int minNumber = 0;
    int maxNumber= 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];;
        minNumber += shipData.minSailorNum;
        maxNumber += shipData.maxSailorNum;
        sailorNumbers += shipData.curSailorNum;
    }
    if (sailorNumbers >= maxNumber) {
        return 0;
    }
    if (sailorNumbers >= minNumber) {
        return maxNumber - sailorNumbers;
    }
    return sailorNumbers - minNumber;
}

-(void)addNpcId:(NSString *)npcId
{
    GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:npcId];
    [(NSMutableArray *)_npcList addObject:npcData];
}

-(void)removeNpcId:(NSString *)npcId
{
    GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:npcId];
    [(NSMutableArray *)_npcList removeObject:npcData];
}

-(void)getShip:(GameShipData *)shipData cityId:(NSString *)cityId
{
    if (!shipData.shipId) {
        [[GameDataManager sharedGameData] registerGameShipData:shipData];
    }
    shipData.belongToGuild = self.belongToGuildId;
    if (self.shipList.count < 5) {
        [_shipList addObject:shipData.shipId];
    } else {
        shipData.cityId = cityId;
        [_carryShipList addObject:shipData.shipId];
    }
}

-(void)removeShip:(GameShipData *)shipData
{
    if (shipData.shipId) {
        if ([_shipList containsObject:shipData.shipId]) {
            [_shipList removeObject:shipData.shipId];
        } else if ([_carryShipList containsObject:shipData.shipId]) {
            [_shipList removeObject:shipData.shipId];
        }
        if (shipData.shipHeader) {
            // TODO: 恶魔船首像装备的船不让卖？
            [shipData unequip:[[GameDataManager sharedGameData].itemDic objectForKey:shipData.shipId]];
        }
        [self.shipDic removeObjectForKey:shipData.shipId];
        shipData.shipId = nil;
    }
}


-(NSArray *)getCarryShipListInCity:(NSString *)cityId
{
    NSMutableArray<GameShipData *>* shipList = [NSMutableArray new];
    for (NSString *shipId in _carryShipList) {
        GameShipData *shipData = [self.shipDic objectForKey:shipId];
        if (shipData.cityId == cityId) {
            [shipList addObject:shipData];
        }
    }
    return shipList;
}


-(NSMutableArray<GameShipData *> *)shipDataList
{
    NSMutableArray *shipList = [NSMutableArray new];
    for (NSString *shipId in _shipList) {
        [shipList addObject:[self.shipDic objectForKey:shipId]];
    }
    return shipList;
}

-(NSMutableArray<GameShipData *> *)carryShipDataList
{
    NSMutableArray *shipList = [NSMutableArray new];
    for (NSString *shipId in _carryShipList) {
        [shipList addObject:[self.shipDic objectForKey:shipId]];
    }
    return shipList;
}

-(CGFloat)getTeamSpeed
{
    int miniSpeed = 0;
    BOOL equipBigFish = NO;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        if (miniSpeed == 0 || miniSpeed < shipData.speed) {
            miniSpeed = shipData.speed;
        }
        if (shipData.shipHeader) {
            GameItemData *header = [[GameDataManager sharedGameData].itemDic objectForKey:shipData.shipHeader];
            if (header.itemData.value == ShipHeaderValueBigbird) {
                equipBigFish = YES;
            }
        }
    }
    return (equipBigFish ? 2 : 1) * miniSpeed;
}

-(NSInteger)shipNumber
{
    return _shipList.count;
}

-(NSInteger)haveSailors
{
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        if (shipData.curSailorNum == 0) {
            return NO;
        }
    }
    return YES;
}

-(NSInteger)haveEnoughSailors
{
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        if (shipData.curSailorNum < shipData.minSailorNum) {
            return NO;
        }
    }
    return YES;
}

-(NSInteger)canSailDays
{
    CGFloat food;
    NSInteger sailors;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = [self.shipDic objectForKey:_shipList[i]];
        food += shipData.foodCapacity;
        sailors += shipData.curSailorNum;
    }
    return food * 200 / sailors;
}

@end
