//
//  MyGuild.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameGuildData.h"
#import "GameTeamData.h"
#import "GameShipData.h"
#import "NpcData.h"

typedef enum : NSUInteger {
    ForsakeTaskSucess,
    ForsakeTaskNotEnoughMoney,
} ForsakeTaskResult;

@class GameTaskData;
@interface MyGuild : GameGuildData

@property (nonatomic, readonly) GameTeamData *myTeam;
@property (nonatomic, readonly) NSSet *usedStorySet;
@property (nonatomic, readonly) GameTaskData *taskData;

-(void)spendMoney:(NSInteger)value succesHandler:(void(^)())successHandle failHandle:(void(^)())failHandle;

-(NpcData *)getLeaderData;

//增加触发的剧情
-(void)addStoryId:(NSString *)storyId;

-(void)takeTask:(GameTaskData *)task;

// 返回0 表示成功，其他值表示失败
-(ForsakeTaskResult)forsakeTask;

// TODO: 有可能要选择奖励
-(void)competeTask;

@end
