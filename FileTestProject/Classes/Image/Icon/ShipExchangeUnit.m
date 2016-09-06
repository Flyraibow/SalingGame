//
//  ShipExchangeUnit.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipExchangeUnit.h"
#import "LocalString.h"
#import "DefaultButton.h"
#import "GameDataManager.h"
#import "SpendMoneyProtocol.h"
#import "GameShipData.h"
#import "DataManager.h"
#import "ShipIcon.h"
#import "ShipScene.h"
#import "GamePanelManager.h"

@interface ShipExchangeUnit() <SpendMoneyProtocol, ShipSceneModifiedDelegate>

@end

@implementation ShipExchangeUnit
{
    CCLabelTTF *_labName;
    ShipIcon *_iconFrame;
    CCLabelTTF *_labPrice;
    DefaultButton *_btnAction;
    GameShipData *_gameShipData;
    NSInteger _dealPrice;
    
    CCLabelTTF *_labShipDuration;
    CCLabelTTF *_labShipMinSailorNum;
    CCLabelTTF *_labShipSpeed;
    CCLabelTTF *_labShipAgile;
    CCLabelTTF *_labShipCannonNum;
    CCLabelTTF *_labShipPosition;
}

-(void)commonInitFunction:(NSString *)iconId;
{
    _iconFrame = [[ShipIcon alloc] initWithShipIconNo:iconId];
    _iconFrame.positionType = CCPositionTypePoints;
    _iconFrame.anchorPoint = ccp(0, 1);
    _iconFrame.position = ccp(10,self.contentSize.height - 10);
    [self addChild:_iconFrame];
    
    _labName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
    _labName.positionType = CCPositionTypePoints;
    _labName.anchorPoint = ccp(0, 1);
    _labName.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width + 10, self.contentSize.height - 10);
    [self addChild:_labName];
    
    _labPrice = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
    _labPrice.positionType = CCPositionTypePoints;
    _labPrice.anchorPoint = ccp(0, 1);
    _labPrice.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width + 10, _labName.position.y - 20);
    [self addChild:_labPrice];
    
    _labShipDuration = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
    _labShipDuration.positionType = CCPositionTypePoints;
    _labShipDuration.anchorPoint = ccp(0, 1);
    _labShipDuration.position = ccp(_iconFrame.position.x, _iconFrame.position.y - _iconFrame.contentSize.height - 5);
    [self addChild:_labShipDuration];
    
    _labShipAgile = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
    _labShipAgile.positionType = CCPositionTypePoints;
    _labShipAgile.anchorPoint = ccp(0, 1);
    _labShipAgile.position = ccp(_labShipDuration.position.x + 85 ,_labShipDuration.position.y);
    [self addChild:_labShipAgile];

    _labShipMinSailorNum = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
    _labShipMinSailorNum.positionType = CCPositionTypePoints;
    _labShipMinSailorNum.anchorPoint = ccp(0, 1);
    _labShipMinSailorNum.position = ccp(_iconFrame.position.x,_labShipDuration.position.y - 20);
    [self addChild:_labShipMinSailorNum];
    
    _labShipSpeed = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
    _labShipSpeed.positionType = CCPositionTypePoints;
    _labShipSpeed.anchorPoint = ccp(0, 1);
    _labShipSpeed.position = ccp(_labShipMinSailorNum.position.x + 85 ,_labShipMinSailorNum.position.y);
    [self addChild:_labShipSpeed];
    
    _labShipCannonNum = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
    _labShipCannonNum.positionType = CCPositionTypePoints;
    _labShipCannonNum.anchorPoint = ccp(0, 1);
    _labShipCannonNum.position = ccp(_iconFrame.position.x, _labShipSpeed.position.y - 20);
    [self addChild:_labShipCannonNum];

    _btnAction = [DefaultButton buttonWithTitle:nil];
    _btnAction.positionType = CCPositionTypeNormalized;
    _btnAction.anchorPoint = ccp(0.5, 0);
    _btnAction.position = ccp(0.5,0.03);
    [_btnAction setTarget:self selector:@selector(clickAction)];
    [self addChild:_btnAction];
    
    _labShipPosition = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
    _labShipPosition.positionType = CCPositionTypeNormalized;
    _labShipPosition.anchorPoint = ccp(1, 0);
    _labShipPosition.position = ccp(0.97,0.03);
    [self addChild:_labShipPosition];
}

-(instancetype)initWithGameShipData:(GameShipData *)gameShipData sceneType:(ShipSceneType)sceneType
{
    if (self = [super initWithImageNamed:@"ShipFrame.png"]) {
        _sceneType = sceneType;
        [self commonInitFunction:gameShipData.shipData.icon];
        [self shipModified:gameShipData];
        
        if (sceneType == ShipSceneTypeBuy) {
            _btnAction.title = getLocalString(@"ship_buy");
        } else if (sceneType == ShipSceneTypeSell) {
            _btnAction.title = getLocalString(@"ship_sell");
        } else if (sceneType == ShipSceneTypeModify) {
            _btnAction.title = getLocalString(@"ship_modify");
        } else if (sceneType == ShipSceneTypeInfo) {
            _btnAction.title = getLocalString(@"ship_Info");
        }
    }
    return self;
}

-(void)setOpacity:(CGFloat)opacity
{
    super.opacity = opacity;
    for (CCNode *node in self.children) {
        node.opacity = opacity;
    }
}

-(void)clickAction
{
    if (_sceneType == ShipSceneTypeBuy) {
        
        [[GameDataManager sharedGameData].myGuild spendMoney:_gameShipData.price target:self spendMoneyType:SpendMoneyTypeBuyShip];

    } else if (_sceneType == ShipSceneTypeSell) {
        [[GameDataManager sharedGameData].myGuild.myTeam.shipList removeObject:_gameShipData];
        [GameDataManager sharedGameData].myGuild.money += _dealPrice;
        [self.delegate ShipDealComplete];
    } else if (_sceneType == ShipSceneTypeModify) {
        // TODO: 进入改造页面
        ShipScene *scene = [[ShipScene alloc] initWithShipData:_gameShipData shipSceneType:DeckShipSceneModify];
        scene.delegate = self;
        [[CCDirector sharedDirector] pushScene:scene];
    } else if (_sceneType == ShipSceneTypeInfo) {
        // 进入甲板画面
        ShipScene *scene = [[ShipScene alloc] initWithShipData:_gameShipData shipSceneType:DeckShipSceneInfo];
        [[CCDirector sharedDirector] pushScene:scene];
    }
}

-(void)shipModified:(GameShipData *)shipData
{
    // TODO: change the price in the future
    _gameShipData = shipData;
    _labName.string = _gameShipData.shipName;
    _dealPrice = shipData.price;
    _labPrice.string = [NSString stringWithFormat:getLocalString(@"ship_price"), _dealPrice];
    _labShipDuration.string = [NSString stringWithFormat:getLocalString(@"ship_duration"),shipData.duration,shipData.maxDuration];
    _labShipAgile.string = [NSString stringWithFormat:getLocalString(@"ship_agile"),shipData.agile];
    _labShipMinSailorNum.string = [NSString stringWithFormat:getLocalString(@"ship_minSailorNum"),shipData.minSailorNum,shipData.curSailorNum,shipData.maxSailorNum];
    _labShipSpeed.string = [NSString stringWithFormat:getLocalString(@"ship_speed"),shipData.speed];
    _labShipCannonNum.string = [NSString stringWithFormat:getLocalString(@"ship_cannonNum"), getCannonName(shipData.cannonId), shipData.cannonNum];
    
    if (_sceneType != ShipSceneTypeBuy) {
        if (_gameShipData.cityId == nil) {
            _labShipPosition.string = getLocalString(@"lab_in_team");
        } else if (_sceneType == ShipSceneTypeSell || _sceneType == ShipSceneTypeModify) {
            _labShipPosition.string = getLocalString(@"lab_in_dock");
        } else if (_sceneType == ShipSceneTypeInfo) {
            _labShipPosition.string = getCityName(shipData.cityId);
        }
    }
}

-(void)spendMoneyFail:(SpendMoneyType)type
{
    DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
    [dialogPanel setDefaultDialog:@"dialog_no_enough_money" arguments:@[]];
}

-(void)spendMoneySucceed:(SpendMoneyType)type
{
    [[GameDataManager sharedGameData].myGuild.myTeam getShip:_gameShipData cityId:self.cityId];
    [self.delegate ShipDealComplete];
}

@end
