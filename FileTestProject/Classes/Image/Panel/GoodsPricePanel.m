//
//  GoodsPricePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/11/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GoodsPricePanel.h"
#import "CityDataPanel.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "DataManager.h"
#import "GoodsData.h"
#import "GoodsIcon.h"
#import "DialogPanel.h"

@interface GoodsPricePanel() <GoodsIconSelectionDelegate, DialogInteractProtocol>

@end

@implementation GoodsPricePanel
{
    CCSprite *_bgSprite;
    CGSize _contentSize;
    DialogPanel *_dialogPanel;
    
    NSString *_cityNo;
    CCLabelTTF *_labCategory;
    CCLabelTTF *_labPrice;
    CCLabelTTF *_labTitle;
    NSMutableDictionary *_labPriceList;
    NSMutableArray *_goodsList;
    NSString *_cateNo;
    CCLabelTTF *_labCate;
    NSDictionary *_goodsDic;
    NSDictionary *_goodsCateType;
    CCLabelTTF *_labCateType;
    NSMutableArray *_labSellBuyList;
}

-(instancetype)init
{
    if (self = [super init]) {
        _contentSize = [CCDirector sharedDirector].viewSize;
        _bgSprite = [CCSprite spriteWithImageNamed:@"bg_trade_info.png"];
        _bgSprite.anchorPoint = ccp(0,0);
        _bgSprite.scale = _contentSize.height / _bgSprite.contentSize.height;
        [self addChild:_bgSprite];
        
        self.positionType = CCPositionTypeNormalized;
        self.anchorPoint = ccp(0, 0);
        self.position = ccp(0 ,0);
        self.contentSize = _bgSprite.boundingBox.size;
        self.userInteractionEnabled = YES;
        
        _labCategory = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labCategory.positionType = CCPositionTypeNormalized;
        _labCategory.position = ccp(0.1,0.875);
        _labCategory.string=[NSString stringWithFormat:getLocalString(@"lab_tradeinfo_category"),nil];
        [_bgSprite addChild:_labCategory];
        
        _labPrice = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labPrice.positionType = CCPositionTypeNormalized;
        _labPrice.position = ccp(0.215, 0.875);
        _labPrice.string=[NSString stringWithFormat:getLocalString(@"lab_tradeinfo_price"),nil];
        [_bgSprite addChild:_labPrice];
        
        _labTitle = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:12];
        _labTitle.positionType = CCPositionTypeNormalized;
        _labTitle.position = ccp(0.55, 0.94);
        [_bgSprite addChild:_labTitle];
        
        _labPriceList=[NSMutableDictionary new];
        
        for(int i = 0; i < 19; i++)
        {
            CCLabelTTF *labCategoryName=[CCLabelTTF labelWithString:getLocalStringByInt(@"category_name_", i+1) fontName:nil fontSize:14];
            labCategoryName.positionType = CCPositionTypeNormalized;
            labCategoryName.position = ccp(0.1, 0.81 - i * 0.0417);
            
            [_bgSprite addChild:labCategoryName];
            
            CCLabelTTF *labPricePercentage=[CCLabelTTF labelWithString:@"100%" fontName:nil fontSize:14];
            labPricePercentage.positionType = CCPositionTypeNormalized;
            labPricePercentage.anchorPoint = ccp(1, 0.5);
            labPricePercentage.position = ccp(0.263, 0.81 - i * 0.0417);
            [_labPriceList setObject:labPricePercentage forKey:@(i+1)];
            [_bgSprite addChild:labPricePercentage];
        }
        
        DefaultButton *closeBtn = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        closeBtn.anchorPoint = ccp(1, 0.5);
        closeBtn.positionType = CCPositionTypeNormalized;
        closeBtn.position = ccp(0.95, 0.05);
        closeBtn.scale = 0.4;
        [self addChild:closeBtn];
        [closeBtn setTarget:self selector:@selector(clickCloseBtn)];
        
        _goodsList=[NSMutableArray new];
        
        _labCate = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labCate.positionType = CCPositionTypeNormalized;
        _labCate.position = ccp(0.52,0.875);
        [_bgSprite addChild:_labCate];
        
        _goodsDic = [[[DataManager sharedDataManager] getGoodsDic] getDictionary];
        _goodsCateType=[[[DataManager sharedDataManager]getGoodsCategoriesDic]getDictionary];
        
        _labCateType = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labCateType.anchorPoint = ccp(0, 0.5);
        _labCateType.positionType = CCPositionTypeNormalized;
        _labCateType.position = ccp(0.6, 0.875);
        [_bgSprite addChild:_labCateType];
        
        _labSellBuyList=[NSMutableArray new];

    }
    
    return self;
}

-(void)setCateNo:(NSString *)cateNo
{
    if (![_cateNo isEqualToString:cateNo]) {
        _cateNo = cateNo;
        for(int i = 0; i < _goodsList.count; i++)
        {
            [_bgSprite removeChild:[_goodsList objectAtIndex:i]];
        }
        [_goodsList removeAllObjects];
        for(int i = 0; i < _labSellBuyList.count; i++)
        {
            [_bgSprite removeChild:[_labSellBuyList objectAtIndex:i]];
        }
        [_labSellBuyList removeAllObjects];
        
        _labCate.string = [NSString stringWithFormat:getLocalStringByInt(@"category_name_", [_cateNo intValue]),nil];
        GoodsCategoriesData *categoryData = [_goodsCateType objectForKey:_cateNo];
        _labCateType.string = [NSString stringWithFormat:getLocalStringByInt(@"category_type_", categoryData.updateType),nil];
        
        int index = 0;
        
        GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:_cityNo];
        
        for (NSString *goodsId in _goodsDic)
        {
            GoodsData *goodsData = [_goodsDic objectForKey:goodsId];
            if (goodsData.type == [cateNo intValue])
            {
                int x=index%4;
                int y=index/4;
                index++;
                
                GoodsIcon *goodsIcon = [[GoodsIcon alloc] initWithShowType:ShowPriceType];
                int buyPrice = [cityData getBuyPriceForGoodsId:goodsId];
                int salePrice = [cityData getSalePriceForGoodsId:goodsId level:5];
                goodsIcon.delegate = self;
                
                // TODO: 以后如果某个产品在流行热销中，价格会显示成红色，并且左上角增加流行索引，可以帮助玩家找到那个产品在热销。
                // 暂时因为没有设置热销商品，暂时不考虑
                [goodsIcon setGoodsId:goodsId buyPrice:buyPrice salePrice:salePrice isOnsale:NO];
                goodsIcon.positionType = CCPositionTypeNormalized;
                goodsIcon.position = ccp(0.5+ x * 0.13,0.7-y*0.25);
                
                [_goodsList addObject:goodsIcon];
                [_bgSprite addChild:goodsIcon];
                
            }
        }
        int num=index/4+(index%4==0?0:1);
        for(int i=0;i<num;i++)
        {
            CCLabelTTF *labBuy=[CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
            labBuy.anchorPoint = ccp(0, 0.5);
            labBuy.positionType = CCPositionTypeNormalized;
            labBuy.position =ccp(0.36, 0.59-i*0.25);
            labBuy.string=[NSString stringWithFormat:getLocalString(@"lab_buy_price"),nil];
            [_bgSprite addChild:labBuy];
            [_labSellBuyList addObject:labBuy];
            
            CCLabelTTF *labSell=[CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
            labSell.anchorPoint = ccp(0, 0.5);
            labSell.positionType = CCPositionTypeNormalized;
            labSell.position = ccp(0.36, 0.64-i*0.25);
            labSell.string=[NSString stringWithFormat:getLocalString(@"lab_sell_price"),nil];
            [_bgSprite addChild:labSell];
            [_labSellBuyList addObject:labSell];
            
        }
    }
}
-(void)setCityNo:(NSString *)cityNo
{
    _cityNo = cityNo;
    for(int i = 0; i < 19; i++)
    {
        CCLabelTTF *pric = [_labPriceList objectForKey:@(i+1)];
        pric.string = @"100%";
    }
    GameCityData *gameCityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
    NSMutableDictionary *categoryPriceDict=gameCityData.categoryPriceDict;
    for(NSNumber * key in categoryPriceDict)
    {
        double value = [[categoryPriceDict objectForKey:key] doubleValue];
        CCLabelTTF *pric = [_labPriceList objectForKey:key];
        pric.string = [NSString stringWithFormat:@("%d%%"),(int)(value * 100)];
    }

    NSString *cityInformation = getLocalStringByString(@"city_name_", cityNo);
    _labTitle.string = [NSString stringWithFormat:getLocalString(@"city_information"),cityInformation];
    [self setCateNo:@"1"];//默认显示种类1
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint point = [touch locationInNode:_bgSprite];
    if (point.x >= 17 && point.x <= 115 && point.y <=315 && point.y>=10)
    {
        int index=(315-point.y)/(double)(305/19) + 1;
        [self setCateNo:[NSString stringWithFormat:@"%d",index]];
    }
    
}

-(void)clickCloseBtn
{
    [self removeFromParent];
}

-(void)selectGoodsIcon:(id)goodsIcon
{
    GoodsIcon *icon = goodsIcon;
    if (_dialogPanel == nil) {
        _dialogPanel = [[DialogPanel alloc] init];
    }
    [_dialogPanel setDialogWithPhotoNo:nil npcName:@"" text:getGoodsDescription(icon.goodsId)];
    [self.scene addChild:_dialogPanel];
}

@end
