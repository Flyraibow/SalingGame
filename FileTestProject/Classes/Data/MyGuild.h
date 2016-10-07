//
//  MyGuild.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameGuildData.h"
#import "SpendMoneyProtocol.h"
#import "UpdateMoneyProtocol.h"
#import "GameTeamData.h"
#import "GameShipData.h"
#import "NpcData.h"

@interface MyGuild : GameGuildData

@property (nonatomic, readonly) GameTeamData *myTeam;
@property (nonatomic, readonly) NSSet *usedStorySet;

-(void)spendMoney:(NSInteger)value succesHandler:(void(^)())successHandle failHandle:(void(^)())failHandle;

-(void)addMoneyUpdateClass:(id<UpdateMoneyProtocol>)target;

-(void)removeMoneyUpdateClass:(id)target;

-(NpcData *)getLeaderData;

//增加触发的剧情
-(void)addStoryId:(NSString *)storyId;

@end
