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

@interface ShipExchangeUnit() <SpendMoneyProtocol>

@end

@implementation ShipExchangeUnit
{
    CCLabelTTF *_labName;
    ShipIcon *_iconFrame;
    CCLabelTTF *_labPrice;
    DefaultButton *_btnBuy;
    ShipData *_shipData;
    GameShipData *_gameShipData;
    NSInteger _dealPrice;
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
    
    _btnBuy = [DefaultButton buttonWithTitle:nil];
    _btnBuy.positionType = CCPositionTypeNormalized;
    _btnBuy.anchorPoint = ccp(0.5, 0);
    _btnBuy.position = ccp(0.5,0.03);
    [self addChild:_btnBuy];
}

-(instancetype)initWithGameShipData:(GameShipData *)gameShipData
{
    if (self = [super initWithImageNamed:@"ShipFrame.png"]) {
        _gameShipData = gameShipData;
        ShipData *shipData = [[DataManager sharedDataManager].getShipDic getShipById:gameShipData.shipNo];
        [self commonInitFunction:shipData.icon];
        
        // TODO: change the price in the future
        _labName.string = gameShipData.shipName;
        _dealPrice = shipData.price;
        _labPrice.string = [NSString stringWithFormat:getLocalString(@"ship_price"), _dealPrice] ;
        _btnBuy.title = getLocalString(@"ship_sell");
        [_btnBuy setTarget:self selector:@selector(clickSell)];
    }
    return self;
}

-(instancetype) initWithShipData:(ShipData *)shipData
{
    if (self = [super initWithImageNamed:@"ShipFrame.png"]) {
        _shipData = shipData;
        
        [self commonInitFunction:shipData.icon];
        
        _labName.string = getLocalStringByString(@"ship_name_",shipData.shipId);
        _labPrice.string = [NSString stringWithFormat:getLocalString(@"ship_price"), shipData.price] ;
        _btnBuy.title = getLocalString(@"ship_buy");
        [_btnBuy setTarget:self selector:@selector(clickBuy)];
        
    }
    return self;
}

-(void)setOpacity:(CGFloat)opacity
{
    super.opacity = opacity;
    _iconFrame.opacity = opacity;
    _labName.opacity = opacity;
    _labPrice.opacity = opacity;
    _btnBuy.opacity = opacity;
}

-(void)clickBuy
{
    [[GameDataManager sharedGameData].myGuild spendMoney:_shipData.price target:self spendMoneyType:SpendMoneyTypeBuyShip];
}

-(void)clickSell
{
    [[GameDataManager sharedGameData].myGuild.myTeam.shipList removeObject:_gameShipData];
    [[GameDataManager sharedGameData].myGuild gainMoney:_dealPrice];
    [self.delegate ShipDealComplete];
}

-(void)spendMoneyFail:(SpendMoneyType)type
{
    
}

-(void)spendMoneySucceed:(SpendMoneyType)type
{
    CCLOG(@"buy ship success");
    [[GameDataManager sharedGameData].myGuild getShip:[[GameShipData alloc] initWithShipData:_shipData]];
    [self.delegate ShipDealComplete];
}

@end
