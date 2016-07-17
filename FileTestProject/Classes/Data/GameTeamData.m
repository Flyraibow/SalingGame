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

static NSString* const GameTeamMoney = @"GameTeamMoney";
static NSString* const GameTeamId = @"GameTeamId";
static NSString* const GameTeamLeader = @"GameTeamLeader";
static NSString* const GameTeamShipList = @"GameTeamShipList";
static NSString* const GameTeamBelongGuildId = @"GameTeamBelongGuildId";
static NSString* const GameTeamCurrentCity = @"GameTeamCurrentCity";
static NSString* const GameTeamNPCData = @"GameTeamNPCData";

@implementation GameTeamData

-(instancetype)initWithTeamData:(TeamData *)teamData guildId:(NSString *)guildId
{
    if (self = [super init]) {
        _shipList = [NSMutableArray new];
        _teamId = teamData.teamId;
        _leaderId = teamData.leaderId;
        _belongToGuildId = guildId;
        NSArray *shipArray = [teamData.shiplist componentsSeparatedByString:@";"];
        for (int i = 0; i < shipArray.count; ++i) {
            NSString *shipTypeId = [shipArray objectAtIndex:i];
            if (shipTypeId.length > 0) {
                GameShipData *shipData = [[GameShipData alloc] initWithShipData:[[DataManager sharedDataManager].getShipDic getShipById:shipTypeId]];
                [_shipList addObject:shipData];
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
        _npcList = [aDecoder decodeObjectForKey:GameTeamNPCData];
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
    [aCoder encodeObject:_npcList forKey:GameTeamNPCData];
}

-(CGFloat)needsFoodCapacity
{
    CGFloat foodCapacity = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = _shipList[i];
        foodCapacity += shipData.maxFoodCapacity - shipData.foodCapacity;
    }
    return foodCapacity;
}

-(void)fillFood:(CGFloat)food
{
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = _shipList[i];
        if (food > 0) {
            food -= shipData.maxFoodCapacity - shipData.foodCapacity;
            shipData.foodCapacity = shipData.maxFoodCapacity;
            if (food < 0) {
                shipData.foodCapacity += food;
                return;
            }
        } else {
            return;
        }
    }
}

-(int)sailorNumbers
{
    BOOL flag = NO;
    int sailorNumbers = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = _shipList[i];
        if (shipData.curSailorNum == 0) {
            // 只要有一条船上没水手，就不能出航
            return 0;
        } else if (shipData.curSailorNum < shipData.minSailorNum) {
            flag = YES;
        }
        sailorNumbers += shipData.curSailorNum;
    }
    if (flag) {
        // 表示至少有一条船的水手没有达到最低要求
        sailorNumbers = - sailorNumbers;
    }
    return sailorNumbers;
}

-(double)totalFood
{
    CGFloat food = 0;
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = _shipList[i];
        food += shipData.foodCapacity;
    }
    return food;
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

@end
