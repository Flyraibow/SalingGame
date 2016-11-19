//
//  CityBuildingGroup.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/3/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CityBuildingGroup.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "BGImage.h"
#import "DataManager.h"
#import "GameEventManager.h"
#import "GameStoryTriggerManager.h"

@implementation CityBuildingGroup
{
    NSString *_cityNo;
    NSMutableDictionary *_btnCityBuildingDict;
    CGSize _contentSize;
}

static double const frameScale = 0.75;
static int const frameOffset = 12;
static int const frameOffsetY = 20;

-(instancetype)init
{
    if (self = [super init]) {
        _contentSize = [[CCDirector sharedDirector] viewSize];
        self.contentSize = CGSizeMake(_contentSize.width * frameScale, _contentSize.height);
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(frameScale / 2,0.5);
        _btnCityBuildingDict = [NSMutableDictionary new];
    }
    return self;
}

-(void)setCityNo:(NSString *)cityNo
{
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
    NSArray *buildingArr = [cityData.buildingSet allObjects];
    for (NSString *buildingNo in _btnCityBuildingDict) {
        CCButton *btnCityBuilding = [_btnCityBuildingDict objectForKey:buildingNo];
        btnCityBuilding.visible = NO;
    }
    for (int i = 0; i < buildingArr.count; ++i) {
        NSString *buildingNo = [buildingArr objectAtIndex:i];
        
        CCButton *btnCityBuilding = [_btnCityBuildingDict objectForKey:buildingNo];
        if (btnCityBuilding == nil) {
            CityBuildingData *cityBuildingData = [[[DataManager sharedDataManager] getCityBuildingDic] getCityBuildingById:buildingNo];
            int index = cityBuildingData.position;
            btnCityBuilding = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"city_building_%@.png", buildingNo]]];
            btnCityBuilding.positionType = CCPositionTypePoints;
            btnCityBuilding.name = buildingNo;
            if (index <= 1) {
                btnCityBuilding.anchorPoint = ccp(0.5,1);
                btnCityBuilding.position = ccp(_contentSize.width * frameScale / 2, _contentSize.height - 10);
            } else if (index % 2 == 0) {
                btnCityBuilding.anchorPoint = ccp(0, 1);
                btnCityBuilding.position = ccp(frameOffset, _contentSize.height - frameOffsetY - 60 * (index / 2 - 1));
            } else {
                btnCityBuilding.anchorPoint = ccp(1,1);
                btnCityBuilding.position = ccp(_contentSize.width * frameScale, _contentSize.height - frameOffsetY - 60 * ((index - 2) / 2));
            }
            [btnCityBuilding setTarget:self selector:@selector(clickBuilding:)];
            [self addChild:btnCityBuilding];
            [_btnCityBuildingDict setObject:btnCityBuilding forKey:buildingNo];

        } else {
            btnCityBuilding.visible = YES;
        }
    }
    if ([_cityNo isEqualToString:cityNo] == NO) {
        _cityNo = cityNo;
    }
}

-(void)gotoBuildingNo:(NSString *)buildingNo
{
    CityBuildingData *cityBuildingData = [[[DataManager sharedDataManager] getCityBuildingDic] getCityBuildingById:buildingNo];
    if (cityBuildingData) {
        [[GameEventManager sharedEventManager] startEventId:cityBuildingData.eventAction withScene:self.scene];
    }
}

-(void)clickBuilding:(CCButton *)button
{
    // 剧情检测
    NSString *buildingId = button.name;
    [GameStoryTriggerManager searchAndStartStory:_cityNo buildingId:buildingId];
    [self gotoBuildingNo:buildingId];
}

@end
