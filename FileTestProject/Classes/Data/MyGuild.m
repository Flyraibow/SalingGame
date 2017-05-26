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
#import "GameTaskData.h"

static NSString* const GameGuildMyTeam = @"GameGuildMyTeam";
static NSString* const GameUsedStorySet = @"GameUsedStorySet";
static NSString* const GamePlayerTaskData = @"GamePlayerTaskData";

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
        _taskData = [aDecoder decodeObjectForKey:GamePlayerTaskData];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_myTeam forKey:GameGuildMyTeam];
    [aCoder encodeObject:_usedStorySet forKey:GameUsedStorySet];
    [aCoder encodeObject:_taskData forKey:GamePlayerTaskData];
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

-(void)takeTask:(GameTaskData *)task
{
    NSAssert(!_taskData, @"Need forsake task befre grab a new one");
    _taskData = task;
}

-(ForsakeTaskResult)forsakeTask
{
    NSAssert(!!_taskData, @"No task to forsake");
    NSInteger money = MAX(_taskData.deposit, 1000) * 5;
    if (self.money < money) {
        return ForsakeTaskNotEnoughMoney;
    } else {
        [self spendMoney:money];
    }
    _taskData = nil;
    return ForsakeTaskSucess;
}

-(void)competeTask
{
    
}

@end
