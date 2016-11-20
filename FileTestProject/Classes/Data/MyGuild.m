//
//  MyGuild.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "MyGuild.h"
#import "DataManager.h"
#import "GameDataObserver.h"

static NSString* const GameGuildMyTeam = @"GameGuildMyTeam";
static NSString* const GameUsedStorySet = @"GameUsedStorySet";

@implementation MyGuild
{
}


-(instancetype)initWithGameGuildData:(GameGuildData *)guildData
{
    if (self = [super initWithGameGuildData:guildData]) {
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

-(void)setMoney:(NSInteger)money
{
    [super setMoney:money];
    _myTeam.teamMoney = self.money;
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_MONEY data:@(money)];
}


-(void)spendMoney:(NSInteger)value succesHandler:(void(^)())successHandle failHandle:(void(^)())failHandle
{
    if (self.money < value) {
        failHandle();
    } else {
        [self spendMoney:value];
        successHandle();
    }
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
