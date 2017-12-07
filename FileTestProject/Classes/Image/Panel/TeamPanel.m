//
//  TeamPanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/5/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "TeamPanel.h"
#import "GameDataManager.h"
#import "DefaultButton.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "RoleInfoPanel.h"
#import "LocalString.h"
#import "ShipExchangePanel.h"

@implementation TeamPanel
{
  __weak GameTeamData *_teamData;
  CCLabelTTF *_labTeamLabel;
  CCLabelTTF *_labTeamLeaderName;
  NSArray<CCLabelTTF *> *_labShipNameList;
  
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  if (self = [self init]) {
  }
  return self;
}

- (instancetype)init
{
  if (self = [super init]) {
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"TeamPanel.png"];
    sprite.anchorPoint = ccp(0.5, 0);
    sprite.positionType = CCPositionTypeNormalized;
    sprite.position = ccp(0.5, 0);
    [self addChild:sprite];
    
    DefaultButton *closeButton = [DefaultButton closeButton];
    closeButton.positionType = CCPositionTypePoints;
    closeButton.position = ccp(282, 24);
    [closeButton setTarget:self selector:@selector(clickCloseButton)];
    [sprite addChild:closeButton];
    
    CCLabelTTF *labTarget = [[CCLabelTTF alloc] initWithString:getLocalString(@"team_panel_target") fontName:nil fontSize:14];
    labTarget.positionType = CCPositionTypePoints;
    labTarget.position = ccp(160, 75);
    [sprite addChild:labTarget];

    _labTeamLabel = [[CCLabelTTF alloc] initWithString:@"" fontName:nil fontSize:14];
    _labTeamLabel.positionType = CCPositionTypePoints;
    _labTeamLabel.position = ccp(22, 167);
    _labTeamLabel.anchorPoint = ccp(0, 0.5);
    [sprite addChild:_labTeamLabel];
    
    _labTeamLeaderName = [[CCLabelTTF alloc] initWithString:@"" fontName:nil fontSize:14];
    _labTeamLeaderName.positionType = CCPositionTypePoints;
    _labTeamLeaderName.position = ccp(22, 145);
    _labTeamLeaderName.anchorPoint = ccp(0, 0.5);
    [sprite addChild:_labTeamLeaderName];
    
    NSMutableArray *labShipNameList = [[NSMutableArray alloc] initWithCapacity:TEAM_MAX_SHIP_NUMBER];
    for (int i = 0; i < TEAM_MAX_SHIP_NUMBER; ++i) {
      CCLabelTTF *labShipName = [[CCLabelTTF alloc] initWithString:@"" fontName:nil fontSize:14];
      labShipName.positionType = CCPositionTypePoints;
      labShipName.position = ccp(22, 120 - i * 24);
      labShipName.anchorPoint = ccp(0, 0.5);
      labShipNameList[i] = labShipName;
      [sprite addChild:labShipName];
    }
    _labShipNameList = labShipNameList;
    
    DefaultButton *btnLeaderInfo = [[DefaultButton alloc] initWithTitle:getLocalString(@"team_panel_leader_info")];
    btnLeaderInfo.positionType = CCPositionTypePoints;
    btnLeaderInfo.position = ccp(274, 112);
    [btnLeaderInfo setTarget:self selector:@selector(clickLeaderInfoButton)];
    [sprite addChild:btnLeaderInfo];
    
    
    DefaultButton *btnShipInfo = [[DefaultButton alloc] initWithTitle:getLocalString(@"team_panel_ship_info")];
    btnShipInfo.positionType = CCPositionTypePoints;
    btnShipInfo.position = ccp(193, 26);
    [btnShipInfo setTarget:self selector:@selector(clickShipInfoButton)];
    [sprite addChild:btnShipInfo];
  }
  return self;
}

- (void)setTeamId:(NSString *)teamId
{
  GameData *gameData = [GameDataManager sharedGameData];
  _teamData = [gameData.teamDic objectForKey:teamId];
  _labTeamLabel.string = _teamData.teamLabel;
  _labTeamLeaderName.string = getNpcFullName(_teamData.leaderId);
  for (int i = 0; i < _teamData.shipList.count; ++i) {
    NSString *shipId = _teamData.shipList[i];
    GameShipData *shipData = [gameData.shipDic objectForKey:shipId];
    _labShipNameList[i].string = shipData.shipName;
  }
  for (NSInteger i = _teamData.shipList.count; i < TEAM_MAX_SHIP_NUMBER; ++i) {
    _labShipNameList[i].string = @"";
  }
}

- (void)clickLeaderInfoButton
{  
  RoleInfoPanel *roleInfoPanel = [[RoleInfoPanel alloc] init];
  [roleInfoPanel setRoleId:_teamData.leaderId];
  [self.scene addChild:roleInfoPanel];
}

- (void)clickCloseButton
{
  [self removeFromParent];
}

- (void)clickShipInfoButton
{
  ShipExchangePanel *shipInfoPanel = [[ShipExchangePanel alloc] initWithType:ShipSceneTypeInfo];
  [shipInfoPanel showShipList:_teamData.shipDataList];
  [self.scene addChild:shipInfoPanel];
}

@end

