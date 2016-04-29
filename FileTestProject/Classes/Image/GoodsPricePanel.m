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
    NSMutableDictionary *_labCategoryList;
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
    
    _labCategory = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:14];
    _labCategory.positionType = CCPositionTypePoints;
    _labCategory.anchorPoint = ccp(0, 1);
    _labCategory.position = ccp(_bgSprite.position.x +18,self.contentSize.height - 30);
    _labCategory.string=[NSString stringWithFormat:getLocalString(@"种类"),nil];
    [self addChild:_labCategory];
    
    _labPrice = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:14];
    _labPrice.positionType = CCPositionTypePoints;
    _labPrice.anchorPoint = ccp(0, 1);
    _labPrice.position = ccp(_bgSprite.position.x +60,self.contentSize.height - 30);
    _labPrice.string=[NSString stringWithFormat:getLocalString(@"行情"),nil];
    [self addChild:_labPrice];

    _labTitle = [CCLabelTTF labelWithString:@"1" fontName:nil fontSize:14];
    _labTitle.positionType = CCPositionTypePoints;
    _labTitle.anchorPoint = ccp(0, 1);
    _labTitle.position = ccp(_bgSprite.position.x +160,self.contentSize.height - 10);
    [self addChild:_labTitle];
    
    _labCategoryList=[NSMutableDictionary new];
    _labPriceList=[NSMutableDictionary new];
    
    for(int i=0;i<19;i++)
    {
        CCLabelTTF *temp=[CCLabelTTF labelWithString:@"1" fontName:nil fontSize:12];
        temp.positionType = CCPositionTypePoints;
        temp.anchorPoint = ccp(0, 1);
        temp.position = ccp(_bgSprite.position.x +16,self.contentSize.height - 30 -22-i*13.3);
        [_labCategoryList setObject:temp forKey:@(i)];
        [self addChild:temp];
        
        CCLabelTTF *temp2=[CCLabelTTF labelWithString:@"1" fontName:nil fontSize:12];
        temp2.positionType = CCPositionTypePoints;
        temp2.anchorPoint = ccp(0, 1);
        temp2.position = ccp(_bgSprite.position.x +60,self.contentSize.height - 30 -22-i*13.3);
        temp2.string=[NSString stringWithFormat:@("100%%"),nil];
        [_labPriceList setObject:temp2 forKey:@(i)];
        [self addChild:temp2];
    }
    
    for(int i=0;i<19;i++)
    {
        NSString *temp=[NSString stringWithFormat:@("category_name_%d"),i+1];
        CCLabelTTF *cate=[_labCategoryList objectForKey:@(i)];
        cate.string=[NSString stringWithFormat:getLocalString(temp),nil];
    }
    return self;
}

-(void)setCityNo:(NSString *)cityNo
{
    _cityNo = cityNo;
    
    NSDictionary *cityDic = [[DataManager sharedDataManager].getCityDic getDictionary];
    CityData *cityData = [cityDic objectForKey:cityNo];
    GameCityData *gameCityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
    NSMutableDictionary *categoryPriceDict=gameCityData.categoryPriceDict;
    for(NSString * key in categoryPriceDict)
    {
        NSString *value=[categoryPriceDict objectForKey:key];
        CCLabelTTF *pric=[_labPriceList objectForKey:key];
        pric.string=[NSString stringWithFormat:@("%@%%"),value];
    }

    NSString *cityInformation=[NSString stringWithFormat:getLocalString([NSString stringWithFormat:@("city_name_%@"),_cityNo]),nil];
    _labTitle.string=[NSString stringWithFormat:getLocalString(@"city_information"),cityInformation];
    
}

@end
