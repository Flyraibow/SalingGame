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

@interface ShipExchangeUnit() <SpendMoneyProtocol>

@end

@implementation ShipExchangeUnit
{
    CCLabelTTF *_labName;
    ShipIcon *_iconFrame;
    CCLabelTTF *_labPrice;
    DefaultButton *_btnAction;
    GameShipData *_gameShipData;
    NSInteger _dealPrice;
    
    CCLabelTTF *_labShipSize;
    CCLabelTTF *_labShipStyle;
    CCLabelTTF *_labShipCapacity;
    CCLabelTTF *_labShipFoodCapacity;
    CCLabelTTF *_labShipDuration;
    CCLabelTTF *_labShipAgile;
    CCLabelTTF *_labShipMinSailorNum;
    CCLabelTTF *_labShipMaxSailorNum;
    CCLabelTTF *_labShipSpeed;
    CCLabelTTF *_labShipCannonNum;
    CCLabelTTF *_labShipCannonPower;
    CCLabelTTF *_labShipSpareRoomNum;
}

-(void)commonInitFunction:(NSString *)iconId;
{
    _iconFrame = [[ShipIcon alloc] initWithShipIconNo:iconId];
    _iconFrame.positionType = CCPositionTypePoints;
    _iconFrame.anchorPoint = ccp(0, 1);
    _iconFrame.position = ccp(10,self.contentSize.height - 10);
    [self addChild:_iconFrame];
    
    _labName = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:15];
    _labName.positionType = CCPositionTypePoints;
    _labName.anchorPoint = ccp(0, 1);
    _labName.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width + 10,self.contentSize.height - 10);
    [self addChild:_labName];
    
    _labPrice = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:13];
    _labPrice.positionType = CCPositionTypePoints;
    _labPrice.anchorPoint = ccp(0, 1);
    _labPrice.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width + 10,_labName.position.y - _labName.contentSize.height - 10);
    [self addChild:_labPrice];
    
    // TODO: 添加其他的属性，如水手，炮数，威力，船速，物资仓库，货物仓库，耐久，灵活//completed
    _labShipDuration = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:13];
    _labShipDuration.positionType = CCPositionTypePoints;
    _labShipDuration.anchorPoint = ccp(0, 1);
    _labShipDuration.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width-50,_labPrice.position.y - _labPrice.contentSize.height - 15);
    [self addChild:_labShipDuration];

    _labShipMinSailorNum = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:13];
    _labShipMinSailorNum.positionType = CCPositionTypePoints;
    _labShipMinSailorNum.anchorPoint = ccp(0, 1);
    _labShipMinSailorNum.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width -50,_labShipDuration.position.y - _labShipDuration.contentSize.height - 6);
    [self addChild:_labShipMinSailorNum];
    
    _labShipSpeed = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:13];
    _labShipSpeed.positionType = CCPositionTypePoints;
    _labShipSpeed.anchorPoint = ccp(0, 1);
    _labShipSpeed.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width -50,_labShipMinSailorNum.position.y - _labShipMinSailorNum.contentSize.height - 6);
    [self addChild:_labShipSpeed];
    
    _labShipCannonNum = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:13];
    _labShipCannonNum.positionType = CCPositionTypePoints;
    _labShipCannonNum.anchorPoint = ccp(0, 1);
    _labShipCannonNum.position = ccp(_iconFrame.position.x + _iconFrame.contentSize.width -50,_labShipSpeed.position.y - _labShipSpeed.contentSize.height - 6);
    [self addChild:_labShipCannonNum];
    
    
    
    _btnAction = [DefaultButton buttonWithTitle:nil];
    _btnAction.positionType = CCPositionTypeNormalized;
    _btnAction.anchorPoint = ccp(0.5, 0);
    _btnAction.position = ccp(0.5,0.03);
    [_btnAction setTarget:self selector:@selector(clickAction)];
    [self addChild:_btnAction];
}

-(instancetype)initWithGameShipData:(GameShipData *)gameShipData sceneType:(ShipSceneType)sceneType
{
    if (self = [super initWithImageNamed:@"ShipFrame.png"]) {
        _sceneType = sceneType;
        _gameShipData = gameShipData;
        ShipData *shipData = [[DataManager sharedDataManager].getShipDic getShipById:gameShipData.shipNo];
        [self commonInitFunction:shipData.icon];
        
        // TODO: change the price in the future
        _labName.string = gameShipData.shipName;
        _dealPrice = shipData.price;
        _labPrice.string = [NSString stringWithFormat:getLocalString(@"ship_price"), _dealPrice];

        //这里
//        CCLabelTTF *_labShipDuration;
         _labShipDuration.string=[NSString stringWithFormat:getLocalString(@"ship_duration"),shipData.duration];
//        CCLabelTTF *_labShipMinSailorNum;
         _labShipMinSailorNum.string=[NSString stringWithFormat:getLocalString(@"ship_minSailorNum"),shipData.minSailorNum];
//        CCLabelTTF *_labShipSpeed;
         _labShipSpeed.string=[NSString stringWithFormat:getLocalString(@"ship_speed"),shipData.speed];
//        CCLabelTTF *_labShipCannonNum;
         _labShipCannonNum.string=[NSString stringWithFormat:getLocalString(@"ship_cannonNum"),shipData.cannonNum];
        
        
        
        if (sceneType == ShipSceneTypeBuy) {
            _btnAction.title = getLocalString(@"ship_buy");
        } else if (sceneType == ShipSceneTypeSell) {
            _btnAction.title = getLocalString(@"ship_sell");
        } else if (sceneType == ShipSceneTypeModify) {
            _btnAction.title = getLocalString(@"ship_modify");
        }
    }
    return self;
}

-(void)setOpacity:(CGFloat)opacity
{
    super.opacity = opacity;
    _iconFrame.opacity = opacity;
    _labName.opacity = opacity;
    _labPrice.opacity = opacity;
    _btnAction.opacity = opacity;
}

-(void)clickAction
{
    if (_sceneType == ShipSceneTypeBuy) {
        [[GameDataManager sharedGameData].myGuild spendMoney:_gameShipData.price target:self spendMoneyType:SpendMoneyTypeBuyShip];

    } else if (_sceneType == ShipSceneTypeSell) {
        [[GameDataManager sharedGameData].myGuild.myTeam.shipList removeObject:_gameShipData];
        [[GameDataManager sharedGameData].myGuild gainMoney:_dealPrice];
        [self.delegate ShipDealComplete];
    } else if (_sceneType == ShipSceneTypeModify) {
        // TODO: 进入改造页面
        ShipScene *scene = [[ShipScene alloc] initWithShipData:_gameShipData shipSceneType:ShipSceneTypeModify];
        [[CCDirector sharedDirector] pushScene:scene];
    }
    
}

-(void)spendMoneyFail:(SpendMoneyType)type
{
    
}

-(void)spendMoneySucceed:(SpendMoneyType)type
{
    CCLOG(@"buy ship success");
    [[GameDataManager sharedGameData].myGuild getShip:_gameShipData];
    [self.delegate ShipDealComplete];
}

@end
