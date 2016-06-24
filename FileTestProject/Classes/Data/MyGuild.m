//
//  MyGuild.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "MyGuild.h"
#import "DataManager.h"

static NSString* const GameGuildMyTeam = @"GameGuildMyTeam";
static NSString* const GameUsedStorySet = @"GameUsedStorySet";

@implementation MyGuild
{
    NSMutableSet *_moneyUpdateSet;
}


-(instancetype)initWithGameGuildData:(GameGuildData *)guildData
{
    if (self = [super initWithGameGuildData:guildData]) {
        _moneyUpdateSet = [NSMutableSet new];
        if (self.teamList.count > 0) {
            _myTeam = [self.teamList objectAtIndex:0];
            [self.teamList removeObjectAtIndex:0];
        } else {
            _myTeam = [GameTeamData new];
        }
        _usedStorySet = [NSMutableSet new];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _moneyUpdateSet = [NSMutableSet new];
        _myTeam = [aDecoder decodeObjectForKey:GameGuildMyTeam];
        _usedStorySet = [aDecoder decodeObjectForKey:GameUsedStorySet];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_myTeam forKey:GameGuildMyTeam];
    [aCoder encodeObject:_usedStorySet forKey:GameUsedStorySet];
}

-(void)updateMoney
{
    for (id<UpdateMoneyProtocol> target in _moneyUpdateSet) {
        [target updateMoney:self.money];
    }
}

-(void)gainMoney:(NSInteger)value
{
    [super gainMoney:value];
    [self updateMoney];
}

-(void)setMoney:(NSInteger)money
{
    [super setMoney:money];
    [self updateMoney];
}

-(void)spendMoney:(NSInteger)value
{
    [super spendMoney:value];
    [self updateMoney];
}

-(void)spendMoney:(NSInteger)value target:(id<SpendMoneyProtocol>)target spendMoneyType:(SpendMoneyType)type
{
    if (self.money < value) {
        [target spendMoneyFail:type];
    } else {
        [self spendMoney:value];
        [self updateMoney];
        [target spendMoneySucceed:type];
    }
}

-(void)addMoneyUpdateClass:(id<UpdateMoneyProtocol>)target
{
    [_moneyUpdateSet addObject:target];
}

-(void)removeMoneyUpdateClass:(id)target
{
    [_moneyUpdateSet removeObject:target];
}

-(void)getShip:(GameShipData *)shipData
{
    [_myTeam.shipList addObject:shipData];
}

-(NpcData *)getLeaderData
{
    return [[[DataManager sharedDataManager] getNpcDic] getNpcById:self.leaderId];
}

-(void)addStoryId:(NSString *)storyId
{
    [(NSMutableSet *)_usedStorySet addObject:storyId];
}

@end
