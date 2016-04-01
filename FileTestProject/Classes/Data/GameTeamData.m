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
        [npcList addObject:[npcDic objectForKey:_leaderId]];
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
    [aCoder encodeObject:_leaderId forKey:GameTeamId];
    [aCoder encodeObject:_shipList forKey:GameTeamShipList];
    [aCoder encodeObject:_belongToGuildId forKey:GameTeamBelongGuildId];
    [aCoder encodeObject:_currentCityId forKey:GameTeamCurrentCity];
    [aCoder encodeObject:_npcList forKey:GameTeamNPCData];
}


-(CheckShipResult)checkShips
{
    if (_shipList.count == 0) {
        return CheckShipResultNoShips;
    }
    for (int i = 0; i < _shipList.count; ++i) {
        GameShipData *shipData = _shipList[i];
        if (shipData.curSailorNum == 0) {
            return CheckShipResultNoSailors;
        }
    }
    
    return CheckShipResultSuccess;
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
