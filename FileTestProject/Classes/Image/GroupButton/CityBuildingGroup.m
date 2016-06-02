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
#import "GovernmentGroupButton.h"
#import "TavernGroupButton.h"
#import "InnGroupButton.h"
#import "ShipyardGroupButton.h"
#import "DockGroupButton.h"
#import "ExchangeGroupButton.h"
#import "ShopGroupButton.h"
#import "BGImage.h"
#import "DataManager.h"

@implementation CityBuildingGroup
{
    NSString *_cityNo;
    NSMutableDictionary *_btnCityBuildingDict;
    BaseButtonGroup *_currentChildSprite;
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
        if (_currentChildSprite != nil && _currentChildSprite.parent == self.scene) {
            [_currentChildSprite removeFromParent];
            _currentChildSprite = nil;
        }
        _cityNo = cityNo;
    }
}

-(void)gotoBuildingNo:(NSString *)buildingNo
{
    if (_currentChildSprite != nil && _currentChildSprite.parent != nil) {
        [_currentChildSprite removeFromParent];
        _currentChildSprite = nil;
    }
    int buildingId = [buildingNo intValue];
    if (buildingId <= 1) {
        // 点击总督府
        GovernmentGroupButton *governmentButton = [[GovernmentGroupButton alloc] initWithCityNo:_cityNo];
        governmentButton.baseSprite = self;
        [self.scene addChild:governmentButton];
        _currentChildSprite = governmentButton;
    } else if (buildingId == 2) {
        // 点击酒馆
        TavernGroupButton *tavernButton = [TavernGroupButton new];
        tavernButton.baseSprite = self;
        [self.scene addChild:tavernButton];
        _currentChildSprite = tavernButton;
        
    } else if (buildingId == 3) {
        // 点击广场
        
    } else if (buildingId == 4) {
        // 点击交易所
        ExchangeGroupButton *exchangeButton = [[ExchangeGroupButton alloc] initWithCityNo:_cityNo];
        exchangeButton.baseSprite = self;
        [self.scene addChild:exchangeButton];
        _currentChildSprite = exchangeButton;
    } else if (buildingId == 5) {
        // 点击造船厂
        ShipyardGroupButton *shipyardButton = [[ShipyardGroupButton alloc] initWithCityNo:_cityNo];
        shipyardButton.baseSprite = self;
        [self.scene addChild:shipyardButton];
        _currentChildSprite = shipyardButton;
    } else if (buildingId == 6) {
        // 点击道具店
        ShopGroupButton *shopButton = [[ShopGroupButton alloc] initWithCityNo:_cityNo];
        shopButton.baseSprite = self;
        [self.scene addChild:shopButton];
        _currentChildSprite = shopButton;
    } else if (buildingId == 7) {
        // 点击码头
        DockGroupButton *dockButton = [DockGroupButton new];
        dockButton.baseSprite = self;
        [self.scene addChild:dockButton];
        _currentChildSprite = dockButton;
    } else if (buildingId == 8) {
        // 点击旅店
        InnGroupButton *innButton = [InnGroupButton new];
        innButton.baseSprite = self;
        [self.scene addChild:innButton];
        _currentChildSprite = innButton;
    } else if (buildingId >= 9) {
        // 点击遗迹等
    }
    _currentChildSprite.buildingNo = buildingNo;
    _currentChildSprite.cityStle = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo].cityStyle;
}

-(void)clickBuilding:(CCButton *)button
{
    // 剧情检测
    [self.delegate checkStory:button.name];
    [self gotoBuildingNo:button.name];
}


-(void)setHidden:(BOOL)hidden
{
    if (_currentChildSprite.hidden || hidden) {
        self.visible = NO;
        _currentChildSprite.visible = NO;
    } else {
        self.visible = YES;
        _currentChildSprite.visible = YES;
    }
}

-(void)showDialog:(NSString *)portraitId npcName:(NSString *)npcName text:(NSString *)text
{
    [super showDialog:portraitId npcName:npcName text:text];
    [self setHidden:YES];
}

-(void)showDialog:(NSString *)npcId text:(NSString *)text
{
    [super showDialog:npcId text:text];
    [self setHidden:YES];
}

-(void)confirm
{
    [super confirm];
    [self setHidden:NO];
    if (_currentChildSprite != nil)
    {
        [_currentChildSprite confirm];
    }
}

-(void)closeButtonGroup:(id)buttonGroup
{
    [_delegate checkStory:@"0"];
}


@end
