//
//  SailMapPanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/27/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "SailMapPanel.h"
#import "SeaAreaData.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "RouteMarkIcon.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BaseButtonGroup.h"
#import "DefaultButton.h"
#import "LabelFrame.h"

@implementation SailMapPanel
{
  id<SailMapPanelDelegate> _delegate;
  NSString *_seaId;
  NSMutableArray<RouteMarkIcon *> *_markButtonList;
  NSString *_selectedSeaId;
  CCSprite *_selectedSeaSprite;
  CCLabelTTF *_labSelectedSea;
  SailSceneType _type;
  LabelFrame *_leftFrame;
  LabelFrame *_rightFrame;
  LabelFrame *_rightUpFrame;
  LabelFrame *_rightDownFrame;
  LabelFrame *_upFrame;
  LabelFrame *_downFrame;
  NSArray<LabelFrame *> *_seaAreaFrameList;
}

- (instancetype)initWithDelegate:(id<SailMapPanelDelegate>)delegate
                           type:(SailSceneType)type
{
  if (self = [super init]) {
    _delegate = delegate;
    _markButtonList = [@[] mutableCopy];
    _type = type;
    _leftFrame = [[LabelFrame alloc] init];
    _leftFrame.positionType = CCPositionTypeNormalized;
    _leftFrame.position = ccp(- 0.02, 0.5);
    _leftFrame.vertical = YES;
    _rightFrame = [[LabelFrame alloc] init];
    _rightFrame.positionType = CCPositionTypeNormalized;
    _rightFrame.position = ccp(1.02, 0.5);
    _rightFrame.contentSize = CGSizeMake(_rightFrame.contentSize.width / 2, _rightFrame.contentSize.height);
    _rightFrame.vertical = YES;
    _rightUpFrame = [[LabelFrame alloc] init];
    _rightUpFrame.positionType = CCPositionTypeNormalized;
    _rightUpFrame.position = ccp(1.02, 0.8);
    _rightUpFrame.vertical = YES;
    _rightUpFrame.contentSize = CGSizeMake(_rightUpFrame.contentSize.width / 2, _rightUpFrame.contentSize.height);
    _rightDownFrame = [[LabelFrame alloc] init];
    _rightDownFrame.positionType = CCPositionTypeNormalized;
    _rightDownFrame.position = ccp(1.02, 0.2);
    _rightDownFrame.vertical = YES;
    _rightDownFrame.contentSize = CGSizeMake(_rightDownFrame.contentSize.width / 2, _rightDownFrame.contentSize.height);
    _upFrame = [[LabelFrame alloc] init];
    _upFrame.positionType = CCPositionTypeNormalized;
    _upFrame.position = ccp(0.5, 1.02);
    _downFrame = [[LabelFrame alloc] init];
    _downFrame.positionType = CCPositionTypeNormalized;
    _downFrame.position = ccp(0.5, - 0.02);
    _seaAreaFrameList = @[_leftFrame, _rightFrame, _rightDownFrame, _rightUpFrame, _upFrame, _downFrame];
    for (int i = 0; i < _seaAreaFrameList.count; ++i) {
      LabelFrame *labelFrame = _seaAreaFrameList[i];
      labelFrame.center = YES;
      [labelFrame setTarget:self selector:@selector(clickSeaAreaButton:)];
      [self addChild:labelFrame];
    }
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)setSeaId:(NSString *)seaId
{
  _seaId = seaId;
  SeaAreaData *seaAreaData = nil;
  CGPoint p1 = CGPointMake(-180, -90);
  CGPoint p2 = CGPointMake(180, 90);
  if ([seaId isEqualToString:@"0"]) {
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"WorldMap.png"]];
    for (int i = 0; i < _seaAreaFrameList.count; ++i) {
      _seaAreaFrameList[i].visible = NO;
    }
  } else {
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"Map%@.jpg", _seaId]]];
    SeaAreaDic *areaDic = [DataManager sharedDataManager].getSeaAreaDic;
    seaAreaData = [areaDic getSeaAreaById:seaId];
    NSAssert(seaAreaData != nil, @"sea area data cannot be nil");
    // node: y2 < y1, x1 < x2
    p1 = CGPointMake(seaAreaData.x1, seaAreaData.y2);
    p2 = CGPointMake(seaAreaData.x2, seaAreaData.y1);
    _leftFrame.name = seaAreaData.left;
    _rightFrame.name = seaAreaData.right;
    _rightDownFrame.name = seaAreaData.rightDown;
    _rightUpFrame.name = seaAreaData.rightUp;
    _upFrame.name = seaAreaData.up;
    _downFrame.name = seaAreaData.down;
    for (int i = 0; i < _seaAreaFrameList.count; ++i) {
      LabelFrame *labelFrame = _seaAreaFrameList[i];
      labelFrame.visible = ![labelFrame.name isEqualToString:@"0"];
      if (labelFrame.visible) {
        labelFrame.string = [areaDic getSeaAreaById:labelFrame.name].areaLabel;
      }
    }
  }
  
  // clear mark buttons
  for (int i = 0; i < _markButtonList.count; ++i) {
    RouteMarkIcon *button = _markButtonList[i];
    [button removeFromParent];
  }
  [_markButtonList removeAllObjects];
  if (seaAreaData != nil) {
    NSDictionary *cityDic = [[DataManager sharedDataManager].getCityDic getDictionary];
    NSMutableSet *currentCitySet = [NSMutableSet new];
    for (NSString *cityNo in cityDic) {
      CityData *cityData = [cityDic objectForKey:cityNo];
      if ([cityData.seaAreaId isEqualToString:_seaId]) {
        [currentCitySet addObject:cityNo];
        GameCityData *gameCityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
        NSString *status = gameCityData.getMyGuildOccupation > 0 ? @"open" : @"close";
        NSString *cityIconName = [NSString stringWithFormat:@"CityMkr%d_%@.png", cityData.cityType, status];
        RouteMarkIcon *cityBtn = [RouteMarkIcon buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:cityIconName]];
        cityBtn.type = RouteMarkIconTypeCity;
        cityBtn.delegate = _delegate;
        cityBtn.buttonLabel = cityData.cityLabel;
        cityBtn.name = cityNo;
        cityBtn.scale = 1.2;
        [cityBtn setTarget:self selector:@selector(clickMapMark:)];
        cityBtn.positionType = CCPositionTypeNormalized;
        CGPoint point = CGPointMake(cityData.longitude, cityData.latitude);
        cityBtn.position = ccp((point.x - p1.x) / (p2.x - p1.x), (point.y - p1.y) / (p2.y - p1.y));
        [self addChild:cityBtn];
        [_markButtonList addObject:cityBtn];
      }
    }
  }
  // always show ships
  NSDictionary *teamDic = [GameDataManager sharedGameData].teamDic;
  for (NSString *teamId in teamDic) {
    GameTeamData *teamData = teamDic[teamId];
    if (_type == SailSceneTypeTradeInfo && ![teamId isEqualToString:[GameDataManager sharedGameData].myGuild.myTeam.teamId]) {
      // only show my team in trade mode.
      continue;
    }
    NSString *teamIconName = [NSString stringWithFormat:@"ShipMkr_%@.png", [teamData relationToGuild:[GameDataManager sharedGameData].myGuild.guildId]];
    RouteMarkIcon *shipBtn = [RouteMarkIcon buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:teamIconName]];
    shipBtn.name = teamId;
    shipBtn.type = RouteMarkIconTypeShip;
    shipBtn.delegate = _delegate;
    shipBtn.buttonLabel = teamData.teamLabel;
    if (_type != SailSceneTypeTradeInfo) {
      [shipBtn setTarget:self selector:@selector(clickMapMark:)];
    }
    CGPoint point = teamData.pos;
    shipBtn.positionType = CCPositionTypeNormalized;
    shipBtn.position = ccp((point.x - p1.x) / (p2.x - p1.x), (point.y - p1.y) / (p2.y - p1.y));
    shipBtn.scale = 1.2;
    [self addChild:shipBtn];
    [_markButtonList addObject:shipBtn];
  }
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  if (_selectedSeaId != nil) {
    NSString *seaAreaId = _selectedSeaId;
    [self removeSelectedArea];
    [_delegate seaAreaIdChanged:seaAreaId];
  }
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  if ([_seaId isEqualToString:@"0"]) {
    NSString *selectSeaId = nil;
    SeaAreaData *seaAreaData = nil;
    CGPoint point = [touch locationInNode:self];
    double longitude = point.x / self.contentSize.width * 360 - 180;
    double latitude = point.y / self.contentSize.height * 180 - 90;
    NSDictionary *seaAreaDic = [[[DataManager sharedDataManager] getSeaAreaDic] getDictionary];
    for (NSString *seaAreaId in seaAreaDic) {
      seaAreaData = seaAreaDic[seaAreaId];
      if (seaAreaData.x1 < longitude && seaAreaData.x2 > longitude && seaAreaData.y1 > latitude && seaAreaData.y2 < latitude ) {
        selectSeaId = seaAreaId;
        break;
      }
    }
    if (_selectedSeaId != selectSeaId) {
      _selectedSeaId = selectSeaId;
      if (selectSeaId != nil) {
        if (_selectedSeaSprite == nil) {
          _selectedSeaSprite = [[CCSprite alloc] init];
          _selectedSeaSprite.anchorPoint = ccp(0, 1);
          _selectedSeaSprite.positionType = CCPositionTypeNormalized;
          _selectedSeaSprite.color = [CCColor yellowColor];
          [self addChild:_selectedSeaSprite];
          _labSelectedSea = [[CCLabelTTF alloc] initWithString:@"" fontName:nil fontSize:15];
          _labSelectedSea.anchorPoint = ccp(0, 1);
          _labSelectedSea.color = [CCColor blueColor];
          _labSelectedSea.positionType = CCPositionTypeNormalized;
          _labSelectedSea.position = ccp(0, 1);
          [_selectedSeaSprite addChild:_labSelectedSea];
        }
        _selectedSeaSprite.spriteFrame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"Map%@.jpg", selectSeaId]];
        _selectedSeaSprite.position = [self normalizedPointFromLatitude:seaAreaData.x1 longitude:seaAreaData.y1];
        _selectedSeaSprite.scaleX = (seaAreaData.x2 - seaAreaData.x1) / 360;
        _selectedSeaSprite.scaleY = (seaAreaData.y1 - seaAreaData.y2) / 180;
        _labSelectedSea.scaleX = 1 / _selectedSeaSprite.scaleX;
        _labSelectedSea.scaleY = 1 / _selectedSeaSprite.scaleY;
        _labSelectedSea.string = seaAreaData.areaLabel;
      } else {
        [self removeSelectedArea];
      }
    }
  }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  [self touchMoved:touch withEvent:event];
}

- (void)clickMapMark:(RouteMarkIcon *)button
{
  NSMutableArray *buttonList = [@[button] mutableCopy];
  for (RouteMarkIcon *icon in _markButtonList) {
    if (icon != button) {
      if (ccpDistance(icon.position, button.position) < 0.02) {
        [buttonList addObject:icon];
      }
    }
  }
  if (buttonList.count > 1) {
    NSMutableArray *buttons = [NSMutableArray new];
    for (RouteMarkIcon *icon in buttonList) {
      DefaultButton *btn = [DefaultButton buttonWithTitle:icon.buttonLabel];
      [btn setTarget:icon selector:@selector(clickButton)];
      [buttons addObject:btn];
    }
    BaseButtonGroup *buttonGroup = [[BaseButtonGroup alloc] initWithNSArray:buttons];
    [self.scene addChild:buttonGroup];
    __weak BaseButtonGroup *weakButtonGroup = buttonGroup;
    [buttonGroup setCallback:^(int index) {
      RouteMarkIcon *btn = buttonList[index];
      [btn clickButton];
      [weakButtonGroup removeFromParent];
    }];
  } else {
    [button clickButton];
  }
}

#pragma private function

- (void)removeSelectedArea
{
  [_selectedSeaSprite removeFromParent];
  _selectedSeaSprite = nil;
  _labSelectedSea = nil;
  _selectedSeaId = nil;
}

- (void)clickSeaAreaButton:(LabelFrame *)frame
{
  NSString *targetAreaId = frame.name;
  [_delegate seaAreaIdChanged:targetAreaId];
}

#pragma private tool

- (CGPoint)normalizedPointFromLatitude:(double)latitude longitude:(double)longtitude
{
  return ccp(latitude / 360 + 0.5, longtitude / 180 + 0.5);
}

@end
