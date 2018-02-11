//
//  PlazaScene.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/14/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "PlazaScene.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "CCButton+Ext.h"
#import "CityDataPanel.h"
#import "GameCityData.h"
#import "PlazaStoreIcon.h"

@implementation PlazaScene
{
  NSArray<PlazaStoreIcon *> *_storeList;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  return [self init];
}

- (instancetype)init
{
  if (self = [super init]) {
    NSString *currentCityNo = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
    CityData *currentCityData = [[[DataManager sharedDataManager] getCityDic] getCityById:currentCityNo];
    CultureData *cultureData = [[[DataManager sharedDataManager] getCultureDic] getCultureById:currentCityData.cultureId];
    CCSprite *background = [CCSprite spriteWithImageNamed:@"PlazaBG.png"];
    background.positionType = CCPositionTypeNormalized;
    background.anchorPoint = ccp(1, 0.5);
    background.position = ccp(0.7, 0.5);
    background.scale =  self.scene.contentSize.height / background.contentSize.height;
    [self addChild:background];

    CityDataPanel *cityDataPanel = [[CityDataPanel alloc] initWithCityNo:currentCityNo sceneType:CityDataPanelPlaza];
    cityDataPanel.anchorPoint = ccp(0, 0.5);
    cityDataPanel.position = ccp(0.7, 0.5);
    [self addChild:cityDataPanel];
    
    CCSprite *grass = [CCSprite spriteWithImageNamed:@"PlazaBGGrass.png"];
    grass.positionType = CCPositionTypePoints;
    grass.anchorPoint = ccp(0, 0);
    grass.position = ccp(0, 104);
    [background addChild:grass z:1];
    
    CCSprite *buildingBG = [CCSprite spriteWithImageNamed:cultureData.PlazaBuilding];
    buildingBG.positionType = CCPositionTypePoints;
    buildingBG.anchorPoint = ccp(0, 0);
    buildingBG.position = ccp(0, 104);
    [background addChild:buildingBG];
    
    NSMutableArray<PlazaStoreIcon *> *storeList = [NSMutableArray new];
    GameCityData *gameCityData = [[[GameDataManager sharedGameData] cityDic] objectForKey:currentCityNo];
    int storeNum = MIN(5, gameCityData.commerceValue / 1500 + 1);
    for (int i = 1; i <= storeNum; ++i) {
      PlazaStoreIcon *storeIcon = [self getPlazaStoreIconByCulureId:currentCityData.cultureId posIndex:i];
      [buildingBG addChild:storeIcon];
      [storeList addObject:storeIcon];
    }
    _storeList = storeList;
    
    CCButton *closeButton = [CCButton buttonWithImageName:@"PlazaLeaveBtn_down.png" highlightedImageName:@"PlazaLeaveBtn_up.png"];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.anchorPoint = ccp(1, 0);
    closeButton.position = ccp(0.98, 0);
    [closeButton setTarget:self selector:@selector(clickCloseButton)];
    [background addChild:closeButton];
    
    // todo: only show this photo when there is some one in pray job
    CCButton *shareGoods = [CCButton buttonWithImageName:@"PlazaSupportBtn_down.png" highlightedImageName:@"PlazaSupportBtn_up.png"];
    shareGoods.positionType = CCPositionTypeNormalized;
    shareGoods.anchorPoint = ccp(0, 0);
    shareGoods.position = ccp(0.02, 0);
    [shareGoods setTarget:self selector:@selector(clickShareGoods)];
    [background addChild:shareGoods];
    
    // todo: only show this photo when there is some one in pray job
    CCButton *shareBestGift = [CCButton buttonWithImageName:@"PlazaBestBtn_down.png" highlightedImageName:@"PlazaBestBtn_up.png"];
    shareBestGift.positionType = CCPositionTypeNormalized;
    shareBestGift.anchorPoint = ccp(0, 0);
    shareBestGift.position = ccp(0.2, 0);
    [shareBestGift setTarget:self selector:@selector(clickShareBestGift)];
    [background addChild:shareBestGift];
    
  }
  return self;
}

-(PlazaStoreIcon *)getPlazaStoreIconByCulureId:(NSString *)cultureId posIndex:(int)index;
{
  assert(index >= 1 && index <= 5);
  PlazaStoreIcon *plazaStoreIcon = [[PlazaStoreIcon alloc] initWithCultureId:cultureId];
  plazaStoreIcon.positionType = CCPositionTypePoints;
  plazaStoreIcon.anchorPoint = ccp(0, 0);
  if (index == 1) {
    plazaStoreIcon.position = ccp(192, 167);
  } else if (index == 2) {
    plazaStoreIcon.position = ccp(112, 167);
  } else if (index == 3) {
    plazaStoreIcon.position = ccp(272, 167);
  } else if (index == 4) {
    plazaStoreIcon.position = ccp(32, 167);
  } else if (index == 5) {
    plazaStoreIcon.position = ccp(352, 167);
  }
  return plazaStoreIcon;
}

- (void)clickCloseButton
{
  [[CCDirector sharedDirector] popScene];
}

- (void)clickShareGoods
{
  
}

- (void)clickShareBestGift
{
  
}

@end
