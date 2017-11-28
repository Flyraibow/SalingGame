//
//  SailScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SailScene.h"
#import "BGImage.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "DataManager.h"
#import "ShipSailModel.h"
#import "DefaultButton.h"
#import "SailSceneShipProtocol.h"
#import "GameRouteData.h"
#import "GoodsPricePanel.h"
#import "GameDataObserver.h"
#import "CityDataPanel.h"
#import "LabelFrame.h"
#import "CCSprite+Ext.h"
#import "SailMapPanel.h"

@interface SailScene()<
NSCopying,
SailSceneShipProtocol,
SailSceneGoProtocol,
SailMapPanelDelegate>

@end

@implementation SailScene
{
  CGSize _contentSize;
  CCLabelTTF *_labMoney;
  CCLabelTTF *_labTime;
  SailMapPanel *_mapSprite;
  double _scale;
  SailSceneType _type;
  NSString *_seaId;
  CityData *_currentCityData;
  CGPoint _beginPoint;
  BOOL _selectPosition;
  CGPoint _mapStartPoint;
  CityDataPanel *_cityPanel;
  NSString *_toCityNo;
  CCButton *_leftButton;
  CCButton *_rightButton;
  CCButton *_upButton;
  CCButton *_downButton;
  NSMutableArray *_cityButtonList;
  BOOL _shipMoving;
  DefaultButton *_btnClose;
  DefaultButton *_btnGotoWorld;
  GameTeamData *_myTeam;
  GoodsPricePanel *_goodsPricePanel;
  CCLabelTTF *_labArea;
  CCLabelTTF *_labCurrentCity;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  NSInteger type = [dataList[0] integerValue];
  if (self = [self initWithType:type]) {
    
  }
  return self;
}

-(instancetype)initWithType:(SailSceneType)type
{
  if (self = [super init]) {
    _type = type;
    NSString *currentCityNo = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
    _currentCityData = [[[DataManager sharedDataManager] getCityDic] getCityById:currentCityNo];
    _seaId = _currentCityData.seaAreaId;
    _contentSize = self.scene.contentSize;
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"sailScene.png"];
    sprite.positionType = CCPositionTypeNormalized;
    sprite.position = ccp(0.5, 0.5);
    _scale = _contentSize.height / sprite.contentSize.height;
    sprite.scale = _scale;
    _mapSprite = [[SailMapPanel alloc] initWithDelegate:self SeaId:_seaId];
    [_mapSprite setRect:CGRectMake(155, 21, 760, 500)];
    [sprite addChild:_mapSprite];
    [self addChild:sprite];
    
    _leftButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed: @"leftArrowButton.png"]];
    _leftButton.positionType = CCPositionTypeNormalized;
    _leftButton.position = ccp(0, 0.5);
    _leftButton.anchorPoint = ccp(0, 0.5);
    [_leftButton setTarget:self selector:@selector(clickLeftButton)];
    [_mapSprite addChild:_leftButton];
    
    _rightButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed: @"rightArrowButton.png"]];
    _rightButton.positionType = CCPositionTypeNormalized;
    _rightButton.position = ccp(1, 0.5);
    _rightButton.anchorPoint = ccp(1, 0.5);
    [_rightButton setTarget:self selector:@selector(clickRightButton)];
    [_mapSprite addChild:_rightButton];
    
    _upButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed: @"upArrowButton.png"]];
    _upButton.positionType = CCPositionTypeNormalized;
    _upButton.position = ccp(0.5, 1);
    _upButton.anchorPoint = ccp(0.5, 1);
    [_upButton setTarget:self selector:@selector(clickUpButton)];
    [_mapSprite addChild:_upButton];
    
    _downButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed: @"downArrowButton.png"]];
    _downButton.positionType = CCPositionTypeNormalized;
    _downButton.position = ccp(0.5, 0);
    _downButton.anchorPoint = ccp(0.5, 0);
    [_downButton setTarget:self selector:@selector(clickDownButton)];
    [_mapSprite addChild:_downButton];
    
    LabelFrame *moneyFrame = [[LabelFrame alloc] initWithPrefix:getLocalString(@"lab_my_money")];
    moneyFrame.string = [@([GameDataManager sharedGameData].myGuild.money) stringValue];
    moneyFrame.positionType = CCPositionTypeNormalized;
    moneyFrame.position = ccp(0.78, 0.98);
    [sprite addChild:moneyFrame];
    
    _cityButtonList = [NSMutableArray new];
    
    LabelFrame *timeFrame = [[LabelFrame alloc] init];
    timeFrame.positionType = CCPositionTypeNormalized;
    timeFrame.position = ccp(0.22, 0.98);
    timeFrame.string = [[GameDataManager sharedGameData] getDateStringWithYear:NO];
    [sprite addChild:timeFrame];
    
    _myTeam = [GameDataManager sharedGameData].myGuild.myTeam;
    [self setSeaArea:_seaId];
    
    _btnClose = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
    _btnClose.anchorPoint = ccp(1, 1);
    _btnClose.positionType = CCPositionTypeNormalized;
    _btnClose.position = ccp(1, 0.97);
    _btnClose.scale = 0.4;
    [_btnClose setTarget:self selector:@selector(clickCloseButton)];
    [self addChild:_btnClose];
    
    SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
    _labArea = [CCLabelTTF labelWithString:seaAreaData.areaLabel fontName:nil fontSize:15];
    _labArea.fontColor = [CCColor whiteColor];
    _labArea.positionType = CCPositionTypePoints;
    _labArea.position = ccp(225, 530);
    [sprite addChild:_labArea];
    
    _btnGotoWorld = [DefaultButton buttonWithTitle:getLocalString(@"lab_goto_world")];
    _btnGotoWorld.anchorPoint = ccp(1, 1);
    _btnGotoWorld.positionType = CCPositionTypeNormalized;
    _btnGotoWorld.position = ccp(1, 0.87);
    _btnGotoWorld.scale = 0.4;
    [_btnGotoWorld setTarget:self selector:@selector(clickGotoWorld)];
    [self addChild:_btnGotoWorld];
    
    
    _shipMoving = NO;
    self.userInteractionEnabled = YES;
    
    [[GameDataObserver sharedObserver] addListenerForKey:LISTENNING_KEY_DATE target:self selector:@selector(updateDate)];
    
    [[GameDataObserver sharedObserver] addListenerForKey:LISTENNING_KEY_MONEY target:self selector:@selector(updateMoney:)];
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
    _leftButton.visible = NO;
    _rightButton.visible = NO;
    _upButton.visible = NO;
    _downButton.visible = NO;
    [_mapSprite setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"WorldMap.png"]];
  } else {
    SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:areaId];
    NSAssert(seaAreaData != nil, @"sea area data cannot be nil");
    _btnGotoWorld.visible = YES;
    _labArea.string = seaAreaData.areaLabel;
  }
}

-(void)clickCity:(CCButton *)cityBtn
{
  NSString *cityNo = cityBtn.name;
  if (_cityPanel == nil) {
    _cityPanel = [[CityDataPanel alloc] initWithCityNo:cityNo sceneType:_type];
    _cityPanel.delegate = self;
  } else {
    [_cityPanel setCityNo:cityNo];
  }
  if (_cityPanel.parent != self) {
    [self addChild:_cityPanel];
  }
  if (_type == SailSceneTypeTradeInfo) {
    if (_goodsPricePanel == nil) {
      _goodsPricePanel = [[GoodsPricePanel alloc] init];
    }
    [_goodsPricePanel setCityNo:cityNo];
    
    if (_goodsPricePanel.parent != self) {
      [self addChild:_goodsPricePanel];
    }
  }
}

-(id)copyWithZone:(NSZone *)zone
{
  return self;
}

-(void)removeAllChildrenWithCleanup:(BOOL)cleanup
{
  [super removeAllChildrenWithCleanup:cleanup];
  [[GameDataObserver sharedObserver] removeAllListenersForTarget:self];
}

-(void)clickLeftButton
{
  SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
  [self setSeaArea:seaAreaData.left];
}

-(void)clickRightButton
{
  SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
  [self setSeaArea:seaAreaData.right];
}

-(void)clickUpButton
{
  SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
  [self setSeaArea:seaAreaData.up];
}

-(void)clickDownButton
{
  SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
  [self setSeaArea:seaAreaData.down];
}

-(void)clickCloseButton
{
  [[CCDirector sharedDirector] popScene];
}

-(void)setShipMovingState:(BOOL)moving
{
  if (_shipMoving != moving) {
    _shipMoving = moving;
    _myTeam.onTheSea = moving;
    if (moving) {
      if (_cityPanel != nil && _cityPanel.parent == self) {
        [_cityPanel removeFromParent];
      }
      _downButton.visible = NO;
      _upButton.visible = NO;
      _rightButton.visible = NO;
      _leftButton.visible = NO;
    } else {
      SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:_seaId];
      _leftButton.visible = ![seaAreaData.left isEqualToString:@"0"];
      _rightButton.visible = ![seaAreaData.right isEqualToString:@"0"];
      _upButton.visible = ![seaAreaData.up isEqualToString:@"0"];
      _downButton.visible = ![seaAreaData.down isEqualToString:@"0"];
    }
    _btnClose.visible = !moving;
    
  }
}

-(void)SailSceneGo:(NSString *)cityNo
{
}

-(void)updateMoney:(NSNumber *)money
{
  _labMoney.string = [money stringValue];
}

-(void)updateDate
{
  _labTime.string = [[GameDataManager sharedGameData] getDateStringWithYear:NO];
}

-(void)changeSeaArea:(NSString *)seaId
{
  [self setSeaArea:seaId];
}

-(void)reachDestinationCity:(NSString *)cityId
{
  [self setShipMovingState:NO];
  [[GameDataManager sharedGameData] moveToCity:cityId];
  [[CCDirector sharedDirector] popScene];
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

