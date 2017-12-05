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

@implementation SailMapPanel
{
  id<SailMapPanelDelegate> _delegate;
  NSString *_seaId;
  NSMutableArray<RouteMarkIcon *> *_markButtonList;
}

- (instancetype)initWithDelegate:(id<SailMapPanelDelegate>)delegate SeaId:(NSString *)seaId
{
  if (self = [super init]) {
    _delegate = delegate;
    _markButtonList = [@[] mutableCopy];
    [self setSeaId:seaId];
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)setSeaId:(NSString *)seaId
{
  _seaId = seaId;
  SeaAreaData *seaAreaData = nil;
  CGPoint p1 = CGPointMake(-180, -180);
  CGPoint p2 = CGPointMake(180, 180);
  if ([seaId isEqualToString:@"0"]) {
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"WorldMap.png"]];
  } else {
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"Map%@.jpg", _seaId]]];
    seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:seaId];
    NSAssert(seaAreaData != nil, @"sea area data cannot be nil");
    // node: y2 < y1, x1 < x2
    p1 = CGPointMake(seaAreaData.x1, seaAreaData.y2);
    p2 = CGPointMake(seaAreaData.x2, seaAreaData.y1);
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
        NSString *cityIconName = [NSString stringWithFormat:@"CityMkr%d_%@.png", cityData.cityScale, status];
        RouteMarkIcon *cityBtn = [RouteMarkIcon buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:cityIconName]];
        cityBtn.type = RouteMarkIconTypeCity;
        cityBtn.delegate = _delegate;
        cityBtn.buttonLabel = cityData.cityLabel;
        cityBtn.name = cityNo;
        [cityBtn setTarget:self selector:@selector(clickMapMark:)];
        cityBtn.positionType = CCPositionTypeNormalized;
        CGPoint point = CGPointMake(cityData.longitude, cityData.latitude);
        cityBtn.position = ccp((point.x - p1.x) / (p2.x - p1.x), (point.y - p1.y) / (p2.y - p1.y));
        [self addChild:cityBtn];
        [_markButtonList addObject:cityBtn];
      }
    }
    NSDictionary *teamDic = [GameDataManager sharedGameData].teamDic;
    for (NSString *teamId in teamDic) {
      GameTeamData *teamData = teamDic[teamId];
      NSString *teamIconName = [NSString stringWithFormat:@"ShipMkr_%@.png", [teamData relationToGuild:[GameDataManager sharedGameData].myGuild.guildId]];
      RouteMarkIcon *shipBtn = [RouteMarkIcon buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:teamIconName]];
      shipBtn.name = teamId;
      shipBtn.type = RouteMarkIconTypeShip;
      shipBtn.delegate = _delegate;
      shipBtn.buttonLabel = teamData.teamLabel;
      [shipBtn setTarget:self selector:@selector(clickMapMark:)];
      CGPoint point = teamData.pos;
      shipBtn.positionType = CCPositionTypeNormalized;
      shipBtn.position = ccp((point.x - p1.x) / (p2.x - p1.x), (point.y - p1.y) / (p2.y - p1.y));
      [self addChild:shipBtn];
      [_markButtonList addObject:shipBtn];
    }
  }
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  CCLOG(@"===========");
  if ([_seaId isEqualToString:@"0"]) {
    CGPoint point = [touch locationInNode:self];
    double longitude = point.x / self.contentSize.width * 360 - 180;
    double latitude = point.y / self.contentSize.height * 180 - 90;
    NSDictionary *seaAreaDic = [[[DataManager sharedDataManager] getSeaAreaDic] getDictionary];
    CCLOG(@"========= pos : %f, %f", longitude, latitude);
    for (NSString *seaAreaId in seaAreaDic) {
      SeaAreaData *seaAreaData = seaAreaDic[seaAreaId];
      if (seaAreaData.x1 < longitude && seaAreaData.x2 > longitude && seaAreaData.y1 > latitude && seaAreaData.y2 < latitude ) {
        CCLOG(@"========= pos : %f, %f  : %@", longitude, latitude, seaAreaData.areaLabel);
        break;
      }
    }
  }
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

@end
