//
//  InfoButtonGroup.m
//  FileTestProject
//
//  Created by FANXUEZHOU on 16/4/30.
//  Copyright © 2016年 Yujie Liu. All rights reserved.
//

#import "InfoButtonGroup.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"
#import "RolePanel.h"
#import "ItemBrowsePanel.h"
#import "GameDataManager.h"

@implementation InfoButtonGroup

-(instancetype)init
{
    DefaultButton *btnShipInfo = [DefaultButton buttonWithTitle:getLocalString(@"lab_ship_info")];
    DefaultButton *btnSailorInfo = [DefaultButton buttonWithTitle:getLocalString(@"lab_sailor_info")];
    DefaultButton *btnItemInfo = [DefaultButton buttonWithTitle:getLocalString(@"lab_item_info")];
    DefaultButton *btnDiaryInfo = [DefaultButton buttonWithTitle:getLocalString(@"lab_diary_info")];
    self = [super initWithNSArray:@[btnShipInfo, btnSailorInfo, btnItemInfo, btnDiaryInfo] CCNodeColor:[BGImage getShadowForBackground]];
    if (self)
    {
        [btnShipInfo setTarget:self selector:@selector(clickShipInfo)];
        [btnSailorInfo setTarget:self selector:@selector(clickSailorInfo)];
        [btnItemInfo setTarget:self selector:@selector(clickItemInfo)];
        [btnDiaryInfo setTarget:self selector:@selector(clickDiaryInfo)];
    }
    return self;
}

-(void)clickShipInfo
{
    // TODO: 列出我所有的船，不仅仅是当前舰队的
//    MyGuild *myGuild = [GameDataManager sharedGameData].myGuild;
//    NSMutableArray<GameShipData *> *shipList = [myGuild.myTeam shipDataList];
//    [shipList addObjectsFromArray:[myGuild.myTeam carryShipDataList]];
//    for (int i = 0; i < myGuild.teamList.count; ++i) {
//        GameTeamData *teamData = myGuild.teamList[i];
//        [shipList addObjectsFromArray:[teamData shipDataList]];
//        [shipList addObjectsFromArray:[teamData carryShipDataList]];
//    }
//    
//    ShipExchangeScene *shipInfoScene = [[ShipExchangeScene alloc] initWithShipList:shipList sceneType:ShipSceneTypeInfo];
//    [[CCDirector sharedDirector] pushScene:shipInfoScene];
}

-(void)clickSailorInfo
{
    NSArray *teamList = [GameDataManager sharedGameData].myGuild.teamList;
    teamList = [teamList arrayByAddingObject:[GameDataManager sharedGameData].myGuild.myTeam];
    NSMutableArray *npcList = [NSMutableArray new];
    for (int i = 0; i < teamList.count; ++i) {
        GameTeamData *teamData = teamList[i];
        [npcList addObjectsFromArray:teamData.npcList];
    }
    
    RolePanel *rolePanel = [[RolePanel alloc] initWithNpcList:npcList type:RolePanelTypeNormal];
    [self.scene addChild:rolePanel];
}

-(void)clickItemInfo
{
    NSArray *items = [[GameDataManager sharedGameData] itemListByGuild:[GameDataManager sharedGameData].myGuild.guildId];
    ItemBrowsePanel *browsePanel = [[ItemBrowsePanel alloc] initWithItems:items panelType:ItemBrowsePanelTypeBrowse];
    [self.scene addChild:browsePanel];
}

-(void)clickDiaryInfo
{
    
}

@end
