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
@implementation GoodsPricePanel
{
    CCSprite *_bgSprite;
    CGSize _contentSize;
    
    NSString *_cityNo;
    CCLabelTTF *_labCategory;
    CCLabelTTF *_labPrice;
    CCLabelTTF *_labTitle;
    NSMutableDictionary *_labPriceList;
}

-(instancetype)init
{
    if (self = [super init]) {
        _contentSize = [CCDirector sharedDirector].viewSize;
        _bgSprite = [CCSprite spriteWithImageNamed:@"bg_trade_info.png"];
        _bgSprite.anchorPoint = ccp(0,1);
        _bgSprite.scale = _contentSize.height / _bgSprite.contentSize.height;
        [self addChild:_bgSprite];
        
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0 ,1);
    }
    
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
    
    return self;
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
    
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // 点击屏幕
}

@end
