//
//  SailMapScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SailMapScene.h"
#import "BGImage.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "DataManager.h"
#import "DefaultButton.h"
#import "GameRouteData.h"
#import "GoodsPricePanel.h"
#import "GameDataObserver.h"
#import "CityDataPanel.h"
#import "LabelFrame.h"
#import "CCSprite+Ext.h"
#import "SailMapPanel.h"
#import "TeamPanel.h"

@interface SailMapScene()<SailMapPanelDelegate>

@end

@implementation SailMapScene
{
  SailMapPanel *_mapSprite;
  CityDataPanelType _type;
  NSString *_seaId;
  CityDataPanel *_cityPanel;
  TeamPanel *_teamPanel;
  DefaultButton *_btnGotoWorld;
  GoodsPricePanel *_goodsPricePanel;
  CCLabelTTF *_labArea;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  NSInteger type = [dataList[0] integerValue];
  return  [self initWithType:type];
}

-(instancetype)initWithType:(CityDataPanelType)type
{
  if (self = [super init]) {
    _type = type;
    NSString *currentCityNo = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
    CityData *currentCityData = [[[DataManager sharedDataManager] getCityDic] getCityById:currentCityNo];
    _seaId = currentCityData.seaAreaId;
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"sailScene.png"];
    sprite.positionType = CCPositionTypeNormalized;
    sprite.position = ccp(0.5, 0.5);
    sprite.scale =  self.scene.contentSize.height / sprite.contentSize.height;
    _mapSprite = [[SailMapPanel alloc] initWithDelegate:self type:type];
    [self setSeaArea:_seaId];
    [_mapSprite setRect:CGRectMake(155, 21, 760, 500)];
    [sprite addChild:_mapSprite];
    [self addChild:sprite];
    
    LabelFrame *moneyFrame = [[LabelFrame alloc] initWithPrefix:getLocalString(@"lab_my_money")];
    moneyFrame.string = [@([GameDataManager sharedGameData].myGuild.money) stringValue];
    moneyFrame.positionType = CCPositionTypeNormalized;
    moneyFrame.position = ccp(0.78, 0.98);
    [sprite addChild:moneyFrame];
    
    LabelFrame *timeFrame = [[LabelFrame alloc] init];
    timeFrame.positionType = CCPositionTypeNormalized;
    timeFrame.position = ccp(0.22, 0.98);
    timeFrame.string = [[GameDataManager sharedGameData] getDateStringWithYear:NO];
    [sprite addChild:timeFrame];
    
    DefaultButton *btnClose = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
    btnClose.anchorPoint = ccp(1, 1);
    btnClose.positionType = CCPositionTypeNormalized;
    btnClose.position = ccp(1, 0.97);
    btnClose.scale = 0.6;
    [btnClose setTarget:self selector:@selector(clickCloseButton)];
    [self addChild:btnClose];
    
    SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
    _labArea = [CCLabelTTF labelWithString:seaAreaData.areaLabel fontName:nil fontSize:15];
    _labArea.fontColor = [CCColor whiteColor];
    _labArea.positionType = CCPositionTypeNormalized;
    _labArea.position = ccp(0.05, 1.02);
    [_mapSprite addChild:_labArea];
    
    CCLabelTTF *labCurrentLocation = [CCLabelTTF labelWithString:currentCityData.cityLabel fontName:nil fontSize:15];
    labCurrentLocation.fontColor = [CCColor whiteColor];
    labCurrentLocation.positionType = CCPositionTypeNormalized;
    labCurrentLocation.position = ccp(0.95, - 0.02);
    [_mapSprite addChild:labCurrentLocation];
    
    _btnGotoWorld = [DefaultButton buttonWithTitle:getLocalString(@"lab_goto_world")];
    _btnGotoWorld.anchorPoint = ccp(1, 1);
    _btnGotoWorld.positionType = CCPositionTypeNormalized;
    _btnGotoWorld.position = ccp(1, 0.87);
    _btnGotoWorld.scale = 0.6;
    [_btnGotoWorld setTarget:self selector:@selector(clickGotoWorld)];
    [self addChild:_btnGotoWorld];
    
    self.userInteractionEnabled = YES;
  }
  return self;
}

-(void)setSeaArea:(NSString *)areaId
{
  _seaId = areaId;
  [_mapSprite setSeaId:areaId];
  if ([areaId isEqualToString:@"0"]) {
    _labArea.string = getLocalString(@"lab_whole_world");
    _btnGotoWorld.visible = NO;
    [_mapSprite setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"WorldMap.png"]];
  } else {
    SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:areaId];
    NSAssert(seaAreaData != nil, @"sea area data cannot be nil");
    _btnGotoWorld.visible = YES;
    _labArea.string = seaAreaData.areaLabel;
  }
}

-(void)clickCity:(NSString *)cityNo
{
  if (_cityPanel == nil) {
    _cityPanel = [[CityDataPanel alloc] initWithCityNo:cityNo sceneType:_type];
  } else {
    [_cityPanel setCityNo:cityNo];
  }
  if (_cityPanel.parent != self) {
    [self addChild:_cityPanel];
  }
  if (_type == CityDataPanelSailTradeInfo) {
    if (_goodsPricePanel == nil) {
      _goodsPricePanel = [[GoodsPricePanel alloc] init];
    }
    [_goodsPricePanel setCityNo:cityNo];
    
    if (_goodsPricePanel.parent != self) {
      [self addChild:_goodsPricePanel];
    }
  }
}

-(void)clickTeam:(NSString *)teamNo
{
  CCLOG(@" ===== click team : %@", teamNo);
  if (_teamPanel == nil) {
    _teamPanel = [[TeamPanel alloc] init];
  }
  [_teamPanel setTeamId:teamNo];
  [self addChild:_teamPanel];
}

-(void)clickCloseButton
{
  [[CCDirector sharedDirector] popScene];
}

-(void)changeSeaArea:(NSString *)seaId
{
  [self setSeaArea:seaId];
}

-(void)closeCityPanel
{
  if (_goodsPricePanel.parent != nil) {
    [_goodsPricePanel removeFromParent];
  }
}

-(void)clickGotoWorld
{
  [self setSeaArea:@"0"];
}

- (void)seaAreaIdChanged:(NSString *)seaId
{
  [self setSeaArea:seaId];
}

@end

