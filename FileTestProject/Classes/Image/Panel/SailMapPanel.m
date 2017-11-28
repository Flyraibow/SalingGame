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
#import "cocos2d.h"
#import "cocos2d-ui.h"

@implementation SailMapPanel
{
  id<SailMapPanelDelegate> _delegate;
  NSString *_seaId;
  NSMutableArray *_cityButtonList;
  NSMutableArray *_shipButtonList;
}

- (instancetype)initWithDelegate:(id<SailMapPanelDelegate>)delegate SeaId:(NSString *)seaId
{
  if (self = [super init]) {
    _delegate = delegate;
    _cityButtonList = [@[] mutableCopy];
    _shipButtonList = [@[] mutableCopy];
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
  
  // clear cities
  for (int i = 0; i < _cityButtonList.count; ++i) {
    CCButton *cityButton = _cityButtonList[i];
    [cityButton removeFromParent];
  }
  [_cityButtonList removeAllObjects];
  // clear ships
  for (CCButton *shipButton in _shipButtonList) {
    [shipButton removeFromParent];
  }
  [_shipButtonList removeAllObjects];
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
        CCButton *cityBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:cityIconName]];
        cityBtn.name = cityNo;
        [cityBtn setTarget:_delegate selector:@selector(clickCity:)];
        cityBtn.positionType = CCPositionTypeNormalized;
        CGPoint point = CGPointMake(cityData.longitude, cityData.latitude);
        cityBtn.position = ccp((point.x - p1.x) / (p2.x - p1.x), (point.y - p1.y) / (p2.y - p1.y));
        [self addChild:cityBtn];
        [_cityButtonList addObject:cityBtn];
      }
    }
    NSDictionary *teamDic = [GameDataManager sharedGameData].teamDic;
    for (NSString *teamId in teamDic) {
      GameTeamData *teamData = teamDic[teamId];
      NSString *teamIconName = [NSString stringWithFormat:@"ShipMkr_%@.png", [teamData relationToGuild:[GameDataManager sharedGameData].myGuild.guildId]];
      CCButton *shipBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:teamIconName]];
      shipBtn.name = teamId;
      CGPoint point = teamData.pos;
      shipBtn.positionType = CCPositionTypeNormalized;
      shipBtn.position = ccp((point.x - p1.x) / (p2.x - p1.x), (point.y - p1.y) / (p2.y - p1.y));
      [self addChild:shipBtn];
      [_cityButtonList addObject:shipBtn];
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


@end
