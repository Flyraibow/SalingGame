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
#import "SailSceneDrawLayer.h"
#import "GameRouteData.h"
#import "GoodsPricePanel.h"
#import "GameDataObserver.h"
#import "CityDataPanel.h"

@interface SailScene()<
NSCopying,
SailSceneShipProtocol,
SailSceneGoProtocol>

@end

@implementation SailScene
{
    CGSize _contentSize;
    CCLabelTTF *_labMoney;
    CCLabelTTF *_labTime;
    ShipSailModel *_ship;
    CCSprite *_mapSprite;
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
    SailSceneDrawLayer *_routesLayer;
    BOOL _shipMoving;
    DefaultButton *_btnClose;
    GameTeamData *_myTeam;
    GoodsPricePanel *_goodsPricePanel;
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
        _seaId = [@(_currentCityData.seaArea) stringValue];
        _contentSize = self.scene.contentSize;
        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"sailScene.png"];
        sprite.positionType = CCPositionTypeNormalized;
        sprite.position = ccp(0.5, 0.5);
        _scale = _contentSize.height / sprite.contentSize.height;
        sprite.scale = _scale;
        _mapSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Map%@.jpg", _seaId]];
        _mapSprite.positionType = CCPositionTypePoints;
        _mapSprite.scale = sprite.scale;
        _mapSprite.position = ccp(_contentSize.width / 2, _contentSize.height / 2);
        _routesLayer = [SailSceneDrawLayer new];
        [_mapSprite addChild:_routesLayer];
        [self addChild:_mapSprite];
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
        
        CCSprite *moneyFrame = [CCSprite spriteWithImageNamed:@"BlackFrame.jpg"];
        moneyFrame.positionType = CCPositionTypeNormalized;
        moneyFrame.position = ccp(0.78, 0.98);
        [sprite addChild:moneyFrame];
        
        _cityButtonList = [NSMutableArray new];
        
        _labMoney = [CCLabelTTF labelWithString:[@([GameDataManager sharedGameData].myGuild.money) stringValue] fontName:nil fontSize:15];
        _labMoney.positionType = CCPositionTypeNormalized;
        _labMoney.position = ccp(0.93, 0.5);
        _labMoney.anchorPoint = ccp(1, 0.5);
        [moneyFrame addChild:_labMoney];
        
        CCLabelTTF *labMoneyTag = [CCLabelTTF labelWithString:getLocalString(@"lab_hold_money") fontName:nil fontSize:15];
        labMoneyTag.positionType = CCPositionTypeNormalized;
        labMoneyTag.position = ccp(0.07, 0.5);
        labMoneyTag.anchorPoint = ccp(0, 0.5);
        [moneyFrame addChild:labMoneyTag];
        
        CCSprite *timeFrame = [CCSprite spriteWithImageNamed:@"BlackFrame.jpg"];
        timeFrame.positionType = CCPositionTypeNormalized;
        timeFrame.position = ccp(0.22, 0.98);
        [sprite addChild:timeFrame];
        
        _labTime = [CCLabelTTF labelWithString:[[GameDataManager sharedGameData] getDateStringWithYear:NO] fontName:nil fontSize:15];
        _labTime.positionType = CCPositionTypeNormalized;
        _labTime.position = ccp(0.93, 0.5);
        _labTime.anchorPoint = ccp(1, 0.5);
        [timeFrame addChild:_labTime];
        
        _myTeam = [GameDataManager sharedGameData].myGuild.myTeam;
        _ship = [[ShipSailModel alloc] initWithTeam:_myTeam];
        _ship.delegate = self;
        _ship.positionType = CCPositionTypePoints;
        _ship.position = ccp(_currentCityData.cityPosX+5,_currentCityData.cityPosY);
        [_mapSprite addChild:_ship z:1];
        
        _ship.currentCityNo = currentCityNo;
        _ship.currentSeaId = _seaId;
        [self setSeaArea:_seaId];
        
        _btnClose = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        _btnClose.anchorPoint = ccp(1, 1);
        _btnClose.positionType = CCPositionTypeNormalized;
        _btnClose.position = ccp(1, 0.97);
        _btnClose.scale = 0.5;
        [_btnClose setTarget:self selector:@selector(clickCloseButton)];
        [self addChild:_btnClose];
        
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
    [_mapSprite setSpriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"Map%@.jpg", _seaId]]];
    [_routesLayer clear];
    
    if (!_shipMoving) {
        SeaAreaData *seaAreaData = [[DataManager sharedDataManager].getSeaAreaDic getSeaAreaById:areaId];
        _leftButton.visible = ![seaAreaData.left isEqualToString:@"0"];
        _rightButton.visible = ![seaAreaData.right isEqualToString:@"0"];
        _upButton.visible = ![seaAreaData.up isEqualToString:@"0"];
        _downButton.visible = ![seaAreaData.down isEqualToString:@"0"];
    }
    
    for (int i = 0; i < _cityButtonList.count; ++i) {
        CCButton *cityButton = _cityButtonList[i];
        [cityButton removeFromParent];
    }
    [_cityButtonList removeAllObjects];
    NSDictionary *cityDic = [[DataManager sharedDataManager].getCityDic getDictionary];
    NSMutableSet *currentCitySet = [NSMutableSet new];
    for (NSString *cityNo in cityDic) {
        CityData *cityData = [cityDic objectForKey:cityNo];
        if (cityData.seaArea == [_seaId intValue]) {
            [currentCitySet addObject:cityNo];
            CCButton *cityBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"city1.png"]];
            cityBtn.name = cityNo;
            [cityBtn setTarget:self selector:@selector(clickCity:)];
            cityBtn.positionType = CCPositionTypePoints;
            cityBtn.position = ccp(cityData.cityPosX, cityData.cityPosY);
            [_mapSprite addChild:cityBtn];
            [_cityButtonList addObject:cityBtn];
        }
    }
    
    if ([_seaId isEqualToString:_ship.currentSeaId]) {
        _ship.visible = YES;
    } else {
        _ship.visible = NO;
    }
    [_routesLayer drawCityRoutes:currentCitySet];
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
    _toCityNo = cityNo;
    if ([_ship.currentCityNo isEqualToString:cityNo]) {
        [[CCDirector sharedDirector] popScene];
        return;
    }
    NSArray *routes = [GameRouteData searchRoutes:_ship.currentCityNo city2:cityNo];
    // invisible some buttons and close the cityPanel;
    [self setShipMovingState:YES];
    
    [self setSeaArea:[@([[[DataManager sharedDataManager] getCityDic] getCityById:_ship.currentCityNo].seaArea) stringValue]];
    [_ship setDirectionList:routes];
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
    _ship.currentSeaId = seaId;
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

@end
