//
//  CityDataPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CityDataPanel.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "GameCityData.h"

@implementation CityDataPanel
{
    CCLabelTTF *_cityName;
    CCLabelTTF *_cityType;
    CCLabelTTF *_cityCountry;
    CCLabelTTF *_labCommerce;
    CCLabelTTF *_labMilltary;
    CCLabelTTF *_cityState;
    NSMutableArray *_labGuildNameArray;
    NSMutableArray *_labOccupationArray;
    NSMutableArray *_labCityGoodsArray;
    NSString *_cityNo;
    
}

-(instancetype)initWithCityNo:(NSString *)cityNo sceneType:(SailSceneType)sceneType
{
    if (self = [super initWithImageNamed:@"cityInfoFrame.png"]) {
        
        _sceneType = sceneType;
        
        CGSize contentSize = [CCDirector sharedDirector].viewSize;
        self.scale = (contentSize.height - 22) / self.contentSize.height;
        self.positionType = CCPositionTypeNormalized;
        self.anchorPoint = ccp(1, 0.5);
        self.position = ccp(1, 0.5);
        
        DefaultButton *closeBtn = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        closeBtn.anchorPoint = ccp(1, 0.5);
        closeBtn.positionType = CCPositionTypeNormalized;
        closeBtn.position = ccp(1, 0.05);
        closeBtn.scale = 0.5;
        [self addChild:closeBtn];
        [closeBtn setTarget:self selector:@selector(clickCloseBtn)];
        
        _cityName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
        _cityName.positionType = CCPositionTypeNormalized;
        _cityName.anchorPoint = ccp(0, 0.5);
        _cityName.position = ccp(0.08, 0.95);
        [self addChild:_cityName];
        
        _cityType = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
        _cityType.positionType = CCPositionTypeNormalized;
        _cityType.anchorPoint = ccp(0, 0.5);
        _cityType.position = ccp(0.08, 0.885);
        [self addChild:_cityType];
        
        _cityCountry = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
        _cityCountry.positionType = CCPositionTypeNormalized;
        _cityCountry.anchorPoint = ccp(0, 0.5);
        _cityCountry.position = ccp(0.43, 0.885);
        [self addChild:_cityCountry];
        
        CCLabelTTF *labCommerceTag = [CCLabelTTF labelWithString:getLocalString(@"MerchantValue") fontName:nil fontSize:15];
        labCommerceTag.positionType = CCPositionTypeNormalized;
        labCommerceTag.anchorPoint = ccp(0, 0.5);
        labCommerceTag.position = ccp(0.07, 0.82);
        [self addChild:labCommerceTag];
        
        CCLabelTTF *labMilltaryTag = [CCLabelTTF labelWithString:getLocalString(@"WeaponValue") fontName:nil fontSize:15];
        labMilltaryTag.positionType = CCPositionTypeNormalized;
        labMilltaryTag.anchorPoint = ccp(0, 0.5);
        labMilltaryTag.position = ccp(0.07, 0.765);
        [self addChild:labMilltaryTag];

        _labCommerce = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
        _labCommerce.positionType = CCPositionTypeNormalized;
        _labCommerce.anchorPoint = ccp(0, 0.5);
        _labCommerce.position = ccp(0.55, 0.82);
        [self addChild:_labCommerce];
        
        _labMilltary = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
        _labMilltary.positionType = CCPositionTypeNormalized;
        _labMilltary.anchorPoint = ccp(0, 0.5);
        _labMilltary.position = ccp(0.55, 0.765);
        [self addChild:_labMilltary];
        
        _cityState = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
        _cityState.positionType = CCPositionTypeNormalized;
        _cityState.anchorPoint = ccp(0.5, 0.5);
        _cityState.position = ccp(0.5, 0.72);
        [self addChild:_cityState];
        
        CCLabelTTF *labGoodsTag = [CCLabelTTF labelWithString:getLocalString(@"cityGoods") fontName:nil fontSize:15];
        labGoodsTag.positionType = CCPositionTypeNormalized;
        labGoodsTag.anchorPoint = ccp(0,0);
        labGoodsTag.position = ccp(0.1, 0.34);
        [self addChild:labGoodsTag];
        
        _labCityGoodsArray = [NSMutableArray new];
        for (int i = 0; i < 5; ++i) {
            CCLabelTTF *labGoods = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
            labGoods.positionType = CCPositionTypeNormalized;
            labGoods.anchorPoint = ccp(0,0);
            labGoods.position = ccp(0.1, 0.30 - i * 0.053);
            [self addChild:labGoods];
            [_labCityGoodsArray addObject:labGoods];
        }
        
        _labGuildNameArray = [NSMutableArray new];
        _labOccupationArray = [NSMutableArray new];
        for (int i = 0; i < 3; ++i) {
            CCLabelTTF *labelOccupation = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
            labelOccupation.positionType = CCPositionTypeNormalized;
            labelOccupation.anchorPoint = ccp(1,0);
            labelOccupation.position = ccp(0.88,0.598 - i * 0.1);
            [self addChild:labelOccupation];
            [_labOccupationArray addObject:labelOccupation];
            
            CCLabelTTF *labelGuildName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
            labelGuildName.positionType = CCPositionTypeNormalized;
            labelGuildName.anchorPoint = ccp(0, 0.5);
            labelGuildName.position = ccp(0.1,0.665 - i * 0.1);
            [self addChild:labelGuildName];
            [_labGuildNameArray addObject:labelGuildName];
        }
        
        [self setCityNo:cityNo];
        
        if (_sceneType == SailSceneTypeGo) {
            
            DefaultButton *btnGo = [DefaultButton buttonWithTitle:@"Go"];
            btnGo.anchorPoint = ccp(0, 0.5);
            btnGo.positionType = CCPositionTypeNormalized;
            btnGo.position = ccp(0, 0.05);
            btnGo.scale = 0.5;
            [self addChild:btnGo];
            [btnGo setTarget:self selector:@selector(clickBtnGo)];
        }
    }
    return self;
}

-(void)setCityNo:(NSString *)cityNo
{
    _cityNo = cityNo;
    
    NSDictionary *cityDic = [[DataManager sharedDataManager].getCityDic getDictionary];
    CityData *cityData = [cityDic objectForKey:cityNo];
    GameCityData *gameCityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
    _cityName.string = getLocalStringByString(@"city_name_", cityNo);
    _cityType.string = getLocalStringByInt(@"city_type_", cityData.cityType);
    _cityCountry.string = getLocalStringByInt(@"city_country_", cityData.country);
    _labCommerce.string = [@(gameCityData.commerceValue) stringValue];
    _labMilltary.string = [@(gameCityData.milltaryValue) stringValue];
    _cityState.string = getLocalStringByInt(@"city_state_", gameCityData.cityState);

    NSArray *array = [cityData.goods componentsSeparatedByString:@";"];
    for (int i = 0; i < array.count; ++i) {
        NSString *goodsId = [array objectAtIndex:i];
        CCLabelTTF *labGoods = [_labCityGoodsArray objectAtIndex:i];
        labGoods.string = getLocalStringByString(@"goods_name_", goodsId);
    }
    
    for (NSUInteger i = array.count; i < 5; ++i) {
        CCLabelTTF *labGoods = [_labCityGoodsArray objectAtIndex:i];
        labGoods.string = @"";
    }
    
    NSArray *guildArray = [gameCityData.guildOccupation keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    for (int i = 0; i < guildArray.count; ++i) {
        NSString *guildNo = guildArray[i];
        CCLabelTTF *labelGuild = _labGuildNameArray[i];
        labelGuild.string = getLocalStringByString(@"guild_name_", guildNo);
        CCLabelTTF *labelOccupation = _labOccupationArray[i];
        labelOccupation.string =[NSString stringWithFormat:@"%@%%",[gameCityData.guildOccupation objectForKey:guildNo]];
    }
    for (NSUInteger i = guildArray.count; i < 3; ++i) {
        CCLabelTTF *labelGuild = _labGuildNameArray[i];
        labelGuild.string = @"";
        CCLabelTTF *labelOccupation = _labOccupationArray[i];
        labelOccupation.string = @"";
    }
}

-(void)clickCloseBtn
{
    [self removeFromParent];
    if ([_delegate respondsToSelector:@selector(closeCityPanel)]) {
        [_delegate closeCityPanel];
    }
}

-(void)clickBtnGo
{
    [_delegate SailSceneGo:_cityNo];
}

@end
