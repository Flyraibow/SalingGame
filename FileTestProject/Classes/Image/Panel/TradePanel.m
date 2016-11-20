//
//  TradePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "TradePanel.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "GameShipData.h"
#import "ShipIcon.h"
#import "GoodsIcon.h"
#import "GameCityData.h"
#import "DataManager.h"
#import "GameShipGoodsData.h"
#import "NSArray+Sort.h"

@interface TradePanel() <ShipIconSelectionDelegate, GoodsIconSelectionDelegate>

@end

@implementation TradePanel
{
    NSArray *_shipList;
    // icon list
    NSMutableArray *_shipGoodsList;
    NSMutableArray *_cityGoodsList;
    NSMutableArray *_soldGoodsList;
    
    NSMutableArray *_soldGoodsDataList;
    
    // make a copy of shipgoods
    NSMutableArray *_shipGoodsCopyList;
    int _shipIndex;
    
    GameCityData *_cityData;
    CCLabelTTF *_labelShipName;
    CCLabelTTF *_labIncome;
    CCLabelTTF *_labOutcome;
    CCLabelTTF *_labBalance;
    NSInteger _totalIncome;
    NSInteger _totalOutcome;
    NSInteger _balance;
    
    NSMutableDictionary *_buyRecordDic;
    NSMutableDictionary *_sellRecordDic;
    DefaultButton *_showBuyPriceBtn;
    ShowType _type;
}

-(instancetype)initWithDataList:(NSArray *)dataList
{
    if (self = [super init]) {
        _cityData = [[GameDataManager sharedGameData].cityDic objectForKey:self.cityId];
        _type = ShowLevel;
        CCSprite *bg = [BGImage getBgImageByName:@"bg_trade.png"];
        [self addChild:bg];
        
        _shipGoodsCopyList = [NSMutableArray new];
        _soldGoodsDataList = [NSMutableArray new];
        _shipList = [GameDataManager sharedGameData].myGuild.myTeam.shipDataList;
        for (int i = 0; i < _shipList.count; ++i) {
            GameShipData *shipData = [_shipList objectAtIndex:i];
            NSMutableArray *goodsList = [NSMutableArray new];
            for (int j = 0; j < shipData.goodsList.count; ++j) {
                GameShipGoodsData *originGoodsData = shipData.goodsList[j];
                GameShipGoodsData *shipGoodsData = [[GameShipGoodsData alloc] initWithGoodsId:originGoodsData.goodsId price:originGoodsData.price level:originGoodsData.level];
                shipGoodsData.newItemIndex = -1;
                [goodsList addObject:shipGoodsData];
            }
            [_shipGoodsCopyList addObject:goodsList];
            [_soldGoodsDataList addObject:[NSMutableArray new]];
        }
        
        DefaultButton *btnCancel = [DefaultButton buttonWithTitle:getLocalString(@"btn_cancel")];
        btnCancel.scale = 0.5;
        btnCancel.anchorPoint = ccp(1,0);
        btnCancel.positionType = CCPositionTypePoints;
        btnCancel.position = ccp(self.contentSize.width - 10, 10);
        [btnCancel setTarget:self selector:@selector(clickCancelButton)];
        [self addChild:btnCancel];
        
        DefaultButton *btnSure = [DefaultButton buttonWithTitle:getLocalString(@"btn_sure")];
        btnSure.scale = 0.5;
        btnSure.anchorPoint = ccp(1,0);
        btnSure.positionType = CCPositionTypePoints;
        btnSure.position = ccp(self.contentSize.width - 10, 30);
        [btnSure setTarget:self selector:@selector(clickSureButton)];
        [self addChild:btnSure];
        
        _showBuyPriceBtn = [DefaultButton buttonWithTitle:getLocalString(@"btn_show_buy_price")];
        _showBuyPriceBtn.scale = 0.5;
        _showBuyPriceBtn.anchorPoint = ccp(1,0);
        _showBuyPriceBtn.positionType = CCPositionTypePoints;
        _showBuyPriceBtn.position = ccp(self.contentSize.width - 10, 50);
        [_showBuyPriceBtn setTarget:self selector:@selector(clickShowBuyPriceButton)];
        [self addChild:_showBuyPriceBtn];
        
        for (int i = 0; i < _shipList.count; ++i) {
            GameShipData *shipData = [_shipList objectAtIndex:i];
            ShipIcon *shipIcon = [[ShipIcon alloc] initWithShipIconNo:shipData.shipIcon];
            shipIcon.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitNormalized,CCPositionReferenceCornerBottomLeft);
            shipIcon.anchorPoint = ccp(0, 1);
            shipIcon.position = ccp(10 + i * shipIcon.contentSize.width, 0.97);
            shipIcon.iconIndex = i;
            shipIcon.delegate = self;
            shipIcon.userInteractionEnabled = YES;
            [self addChild:shipIcon];
        }
        
        _soldGoodsList = [NSMutableArray new];
        for (int i = 0; i < 5; ++i) {
            GoodsIcon *icon = [[GoodsIcon alloc] initWithShowType:_type];
            icon.positionType = CCPositionTypePoints;
            icon.anchorPoint = ccp(0, 0.5);
            icon.goodsIndex = i;
            icon.goodsType = GoodsIconTypeSoldGoods;
            icon.delegate = self;
            double scale = (self.contentSize.width / 2 - 30) / 5 / icon.contentSize.width;
            icon.scale = scale;
            icon.position = ccp(self.contentSize.width / 2 + i * icon.contentSize.width * icon.scale, self.contentSize.height * 0.53);
            [_soldGoodsList addObject:icon];
            [self addChild:icon];
        }
        
        _shipGoodsList = [NSMutableArray new];
        for (int i = 0; i < 5; ++i) {
            GoodsIcon *icon = [[GoodsIcon alloc] initWithShowType:_type];
            icon.positionType = CCPositionTypePoints;
            icon.anchorPoint = ccp(0, 0.5);
            double scale = (self.contentSize.width / 2 - 30) / 5 / icon.contentSize.width;
            icon.scale = scale;
            icon.position = ccp(10 + i * icon.contentSize.width * icon.scale, self.contentSize.height*0.53);
            icon.visible = NO;
            icon.goodsIndex = i;
            icon.goodsType = GoodsIconTypeShipGoods;
            icon.delegate = self;
            [self addChild:icon];
            [_shipGoodsList addObject:icon];
        }
        
        CCLabelTTF *label1 = [CCLabelTTF labelWithString:getLocalString(@"lab_sold") fontName:nil fontSize:12];
        label1.positionType = CCPositionTypeNormalized;
        label1.position = ccp(0.555, 0.725);
        [self addChild:label1];
        
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:getLocalString(@"lab_sell") fontName:nil fontSize:12];
        label2.positionType = CCPositionTypeNormalized;
        label2.position = ccp(0.07, 0.35);
        [self addChild:label2];
        
        CCLabelTTF *labelOutcome = [CCLabelTTF labelWithString:getLocalString(@"lab_outcome") fontName:nil fontSize:10];
        labelOutcome.positionType = CCPositionTypeNormalized;
        labelOutcome.anchorPoint = ccp(0, 0.5);
        labelOutcome.position = ccp(0.58, 0.18);
        [self addChild:labelOutcome];
        
        CCLabelTTF *labelIncome = [CCLabelTTF labelWithString:getLocalString(@"lab_income") fontName:nil fontSize:10];
        labelIncome.positionType = CCPositionTypeNormalized;
        labelIncome.anchorPoint = ccp(0, 0.5);
        labelIncome.position = ccp(0.58, 0.135);
        [self addChild:labelIncome];
        
        CCLabelTTF *labBalance = [CCLabelTTF labelWithString:getLocalString(@"lab_balance") fontName:nil fontSize:10];
        labBalance.positionType = CCPositionTypeNormalized;
        labBalance.anchorPoint = ccp(0, 0.5);
        labBalance.position = ccp(0.58, 0.075);
        [self addChild:labBalance];
        
        _labOutcome = [CCLabelTTF labelWithString:@"0" fontName:nil fontSize:10];
        _labOutcome.positionType = CCPositionTypeNormalized;
        _labOutcome.anchorPoint = ccp(1, 0.5);
        _labOutcome.position = ccp(0.8, 0.18);
        [self addChild:_labOutcome];
        
        _labIncome = [CCLabelTTF labelWithString:@"0" fontName:nil fontSize:10];
        _labIncome.positionType = CCPositionTypeNormalized;
        _labIncome.anchorPoint = ccp(1, 0.5);
        _labIncome.position = ccp(0.8, 0.135);
        [self addChild:_labIncome];
        
        _balance = [GameDataManager sharedGameData].myGuild.money;
        _labBalance = [CCLabelTTF labelWithString:[@(_balance) stringValue] fontName:nil fontSize:10];
        _labBalance.positionType = CCPositionTypeNormalized;
        _labBalance.anchorPoint = ccp(1, 0.5);
        _labBalance.position = ccp(0.8, 0.075);
        [self addChild:_labBalance];
        
        _labelShipName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:12];
        _labelShipName.positionType = CCPositionTypeNormalized;
        _labelShipName.anchorPoint = ccp(0, 0.5);
        _labelShipName.position = ccp(0.03, 0.725);
        [self addChild:_labelShipName];
        
        _totalIncome = 0;
        _totalOutcome = 0;
        
        _buyRecordDic = [NSMutableDictionary new];
        _sellRecordDic = [NSMutableDictionary new];
        
        if (_shipList.count > 0) {
            [self showShipIndex:0];
        }
        _cityGoodsList = [NSMutableArray new];
        CGSize contentSize = [CCDirector sharedDirector].viewSize;
        int index = 0;
        NSArray *goodsList = [[_cityData.goodsDict allKeys] sortByNumberAscending:YES];
        for (NSString *goodsId in goodsList) {
            int level = [_cityData getGoodsLevel:goodsId];
            int price = [_cityData getBuyPriceForGoodsId:goodsId level:level];
            GoodsIcon *icon = [[GoodsIcon alloc] initWithShowType:ShowCityGoods];
            [icon setGoods:goodsId price:price level:level buyPrice:-1];
            icon.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitNormalized,CCPositionReferenceCornerBottomLeft);
            icon.anchorPoint = ccp(0, 0);
            double scale = (contentSize.width / 2 - 30) / 5 / icon.contentSize.width;
            icon.scale = scale;
            icon.position = ccp(10 + index * icon.contentSize.width * icon.scale, 0.03);
            [icon setNumber:[_cityData getGoodsNumForGuild:[GameDataManager sharedGameData].myGuild.guildId goodsId:goodsId]];
            icon.goodsIndex = index;
            icon.goodsType = GoodsIconTypeCityGoods;
            icon.delegate = self;
            [_cityGoodsList addObject:icon];
            [self addChild:icon];
            index++;
        }
    }
    return self;
}

-(void)showShipIndex:(int)index
{
    _shipIndex = index;
    GameShipData *currentShip = _shipList[index];
    NSMutableArray *currentGoodsList = [_shipGoodsCopyList objectAtIndex:index];
    _labelShipName.string = currentShip.shipName;
    for (int i = 0; i < currentGoodsList.count; ++i) {
        GoodsIcon *icon = [_shipGoodsList objectAtIndex:i];
        icon.visible =  YES;
        GameShipGoodsData *goodsData = [currentGoodsList objectAtIndex:i];
        icon.goodsId = goodsData.goodsId;
        int price;
        icon.newItemIndex = goodsData.newItemIndex;
        if (icon.newItemIndex >= 0) {
            icon.type = ShowNewBuyGoods;
            price = goodsData.price;
        } else {
            icon.type = _type;
            price = [_cityData getSalePriceForGoodsId:goodsData.goodsId level:goodsData.level];
        }
        [icon setGoods:goodsData.goodsId price:price level:goodsData.level buyPrice:goodsData.price];
    }
    for (NSUInteger i = currentGoodsList.count; i < 5; ++i) {
        GoodsIcon *icon = [_shipGoodsList objectAtIndex:i];
        icon.visible = NO;
    }
    [self updateShipSoldGoods];
}

-(void)updateShipSoldGoods
{
    NSMutableArray *soldGoodsList = [_soldGoodsDataList objectAtIndex:_shipIndex];
    for (int i = 0; i < soldGoodsList.count; ++i) {
        GameShipGoodsData *goodsData = [soldGoodsList objectAtIndex:i];
        GoodsIcon *icon = [_soldGoodsList objectAtIndex:i];
        icon.type = _type;
        int price = [_cityData getSalePriceForGoodsId:goodsData.goodsId level:goodsData.level];
        [icon setGoods:goodsData.goodsId price:price level:goodsData.level buyPrice:goodsData.price];
    }
    for (NSUInteger i = soldGoodsList.count; i < 5; ++i) {
        GoodsIcon *icon = [_soldGoodsList objectAtIndex:i];
        [icon setGoods:nil price:0 level:0 buyPrice:-1];
        icon.goodsId = nil;
    }
}

-(void)clickShowBuyPriceButton
{
    if (_type == ShowLevel) {
        _type = ShowBuyPrice;
        _showBuyPriceBtn.title = getLocalString(@"btn_show_level");
        
    } else {
        _type = ShowLevel;
        _showBuyPriceBtn.title = getLocalString(@"btn_show_buy_price");
    }
    // 船只上已经显示的价格改写
    [self showShipIndex:_shipIndex];
    [self updateShipSoldGoods];
}

-(void)clickCancelButton
{
    [self removeFromParent];
    self.completionBlockWithEventId(self.cancelEvent);
}

-(void)clickSureButton
{
    // TODO: 确定有进行交易，否则按照取消来结算
    // 资金不够的时候有文字提示
    // 购买成功时也加入文字提示，以后可能会更加的复杂
    if(_balance + _totalIncome - _totalOutcome >= 0) {
        if (_buyRecordDic.count > 0 || _sellRecordDic.count > 0) {
            // change the goods
            for (int i = 0; i < _shipList.count; ++i) {
                GameShipData *shipData = [_shipList objectAtIndex:i];
                NSMutableArray *goodsList = [_shipGoodsCopyList objectAtIndex:i];
                for (int j = 0; j < shipData.goodsList.count; ++j) {
                    GameShipGoodsData *originGoodsData = shipData.goodsList[j];
                    GameShipGoodsData *shipGoodsData = goodsList[j];
                    
                    [originGoodsData setGoodsId:shipGoodsData.goodsId price:shipGoodsData.price level:shipGoodsData.level];
                }
            }
            
            MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
            myguild.money += _totalIncome - _totalOutcome;
            [_cityData addTransactionRecord:myguild.guildId buyRecord:_buyRecordDic sellRecord:_sellRecordDic];
        }
        
        [self removeFromParent];
        self.completionBlockWithEventId(self.successEvent);
    }
}

-(void)selectShipIconIndex:(id)shipIcon
{
    ShipIcon *icon = shipIcon;
    [self showShipIndex:icon.iconIndex];
}

-(void)selectGoodsIcon:(id)goodsIcon
{
    GoodsIcon *icon = goodsIcon;
    if (icon.goodsType == GoodsIconTypeCityGoods) {
        // 购买货物
        if (icon.number > 0) {
            // check is there any space for the goods
            for (int i = 0; i < _shipGoodsList.count; ++i) {
                GoodsIcon *goodsIcon = [_shipGoodsList objectAtIndex:i];
                if (goodsIcon.visible && goodsIcon.isEmpty) {
                    GameShipGoodsData *goodsData = [[_shipGoodsCopyList objectAtIndex:_shipIndex] objectAtIndex:i];
                    [goodsData setGoodsId:icon.goodsId price:icon.price level:icon.level];
                    goodsData.newItemIndex = icon.goodsIndex;
                    _totalOutcome += icon.price;
                    goodsIcon.type = ShowNewBuyGoods;
                    [goodsIcon setGoods:icon.goodsId price:icon.price level:icon.level buyPrice:icon.price];
                    goodsIcon.goodsId = icon.goodsId;
                    [icon setNumber:icon.number - 1];
                    goodsIcon.newItemIndex = icon.goodsIndex;
                    if ([_buyRecordDic objectForKey:icon.goodsId] != nil)
                        [_buyRecordDic setObject:@([[_buyRecordDic objectForKey:icon.goodsId] intValue] + 1) forKey:icon.goodsId];
                    else
                        [_buyRecordDic setObject:@(1) forKey:icon.goodsId];
                    _labOutcome.string = [NSString stringWithFormat:@"%zd",_totalOutcome];
                    _labBalance.string = [@(_balance + _totalIncome - _totalOutcome) stringValue];
                    break;
                }
            }
        }
    } else if(icon.goodsType == GoodsIconTypeShipGoods) {
        if (icon.newItemIndex >= 0) {
            //取消购买
            GameShipGoodsData *goodsData = [[_shipGoodsCopyList objectAtIndex:_shipIndex] objectAtIndex:icon.goodsIndex];
            [goodsData setGoodsId:nil price:0 level:0];
            if ([[_buyRecordDic objectForKey:icon.goodsId] intValue] > 0)
            {
                [_buyRecordDic setObject:@([[_buyRecordDic objectForKey:icon.goodsId] intValue] - 1) forKey:icon.goodsId];
            } else {
                [_buyRecordDic removeObjectForKey:icon.goodsId];
            }
            GoodsIcon *cityGoods = [_cityGoodsList objectAtIndex:icon.newItemIndex];
            _totalOutcome -= icon.price;
            _labOutcome.string = [NSString stringWithFormat:@"%zd",_totalOutcome];
            _labBalance.string = [@(_balance + _totalIncome - _totalOutcome) stringValue];
            [cityGoods setNumber:cityGoods.number+1];
            cityGoods.newItemIndex = -1;
            [icon setGoods:nil price:0 level:0 buyPrice:-1];
            icon.goodsId = nil;
            icon.type = _type;
        } else {
            //卖出货物
            for (int i = 0; i < 5; ++i) {
                GoodsIcon *soldGoods = [_soldGoodsList objectAtIndex:i];
                if (soldGoods.isEmpty) {
                    GameShipGoodsData *goodsData = [[_shipGoodsCopyList objectAtIndex:_shipIndex] objectAtIndex:icon.goodsIndex];
                    if ([_sellRecordDic objectForKey:icon.goodsId] != nil)
                    {
                        [_sellRecordDic setObject:@([[_sellRecordDic objectForKey:icon.goodsId] intValue] + 1) forKey:icon.goodsId];
                    } else {
                        [_sellRecordDic setObject:[@(1) stringValue] forKey:icon.goodsId];
                    }
                    NSMutableArray * soldGoodsDataList = [_soldGoodsDataList objectAtIndex:_shipIndex];
                    [soldGoodsDataList addObject:[[GameShipGoodsData alloc] initWithGoodsId:goodsData.goodsId price:goodsData.price level:goodsData.level]];
                    [goodsData setGoodsId:nil price:0 level:0];
                    _totalIncome += icon.price;
                    _labIncome.string = [NSString stringWithFormat:@"%zd",_totalIncome];
                    _labBalance.string = [@(_balance + _totalIncome - _totalOutcome) stringValue];
                    [soldGoods setGoods:icon.goodsId price:icon.price level:icon.level buyPrice:icon.buyPrice];
                    [icon setGoods:nil price:0 level:0 buyPrice:-1];
                    break;
                }
            }
        }
    } else if(icon.goodsType == GoodsIconTypeSoldGoods) {
        //取消售出
        for (int i = 0; i < 5; ++i) {
            GoodsIcon *shipGoods = [_shipGoodsList objectAtIndex:i];
            if (shipGoods.visible && shipGoods.isEmpty) {
                if ([[_sellRecordDic objectForKey:icon.goodsId] intValue] > 0)
                {
                    [_sellRecordDic setObject:@([[_sellRecordDic objectForKey:icon.goodsId] intValue] - 1) forKey:icon.goodsId];
                } else {
                    [_sellRecordDic removeObjectForKey:icon.goodsId];
                }
                GameShipGoodsData *goodsData = [[_shipGoodsCopyList objectAtIndex:_shipIndex] objectAtIndex:i];
                [goodsData setGoodsId:icon.goodsId price:icon.buyPrice level:icon.level];
                goodsData.newItemIndex = -1;
                [[_soldGoodsDataList objectAtIndex:_shipIndex] removeObjectAtIndex:icon.goodsIndex];
                for (int j = icon.goodsIndex; j < 4; ++j) {
                    GoodsIcon *soldGoods1 = [_soldGoodsList objectAtIndex:j];
                    GoodsIcon *soldGoods2 = [_soldGoodsList objectAtIndex:j+1];
                    soldGoods1.goodsId = soldGoods2.goodsId;
                }
                
                _totalIncome -= icon.price;
                _labBalance.string = [@(_balance + _totalIncome - _totalOutcome) stringValue];
                _labIncome.string = [NSString stringWithFormat:@"%zd",_totalIncome];
                [shipGoods setGoods:goodsData.goodsId price:icon.price level:icon.level buyPrice:icon.buyPrice];
                [icon setGoods:nil price:0 level:0 buyPrice:-1];
                [self updateShipSoldGoods];
                break;
            }
        }
    }
    CCLOG(@"%zd, %d",icon.goodsType, icon.goodsIndex);
}

@end
