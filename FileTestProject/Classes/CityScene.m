//
//  CityScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 1/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CityScene.h"
#import "BGImage.h"
#import "CityData.h"
#import "GoodsData.h"
#import "DataManager.h"
#import "LocalString.h"
#import "CitySystemBar.h"
#import "InvestPanel.h"
#import "GameDataManager.h"
#import "CityBuildingGroup.h"
#import "DateUpdateProtocol.h"
#import "GameCityData.h"
#import "OccupationUpdateProtocol.h"
#import "GameStoryTriggerManager.h"
#import "CGStoryScene.h"
#import "GamePanelManager.h"

@interface CityScene() <
DateUpdateProtocol,
OccupationUpdateProtocol,
CGStorySceneDelegate,
CityBuildingDelegate>

@end

@implementation CityScene
{
    NSString *_cityNo;
    CCLabelTTF *_cityName;
    CCLabelTTF *_cityType;
    CCLabelTTF *_cityBelong;
    CCLabelTTF *_cityState;
    NSMutableArray *_labCityGoodsArray;
    CCLabelTTF *_labMerchantValue;
    CCLabelTTF *_labWeaponValue;
    CityData *_cityData;
    CCLabelTTF *_labDate;
    CCLabelTTF *_labMyMoney;
    NSMutableArray *_labGuildNameArray;
    NSMutableArray *_labOccupationArray;
    CCSprite *_cityBg;
    CityBuildingGroup *_cityBuildingGroup;
}

-(instancetype)init
{
    self = [super init];
    assert(self);
    // city data
    CGSize contentSize = [[CCDirector sharedDirector] viewSize];
    _cityBg = [CCSprite spriteWithImageNamed:@"Town_1.png"];
    _cityBg.positionType = CCPositionTypePoints;
    _cityBg.scaleX = contentSize.width / _cityBg.contentSize.width * 0.75;
    _cityBg.scaleY = contentSize.height / _cityBg.contentSize.height;
    _cityBg.position = ccp(_cityBg.contentSize.width * _cityBg.scaleX / 2, contentSize.height / 2);
    [self addChild:_cityBg];
    
    CCSprite *bgImage = [BGImage getBgImageByName:@"City_Background.png"];
    [self addChild:bgImage];
    
    _cityName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
    _cityName.positionType = CCPositionTypeNormalized;
    _cityName.anchorPoint = ccp(0,0);
    _cityName.position = ccp(0.79, 0.925);
    [self addChild:_cityName];
    
    _cityType = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
    _cityType.positionType = CCPositionTypeNormalized;
    _cityType.anchorPoint = ccp(0,0);
    _cityType.position = ccp(0.79, 0.86);
    [self addChild:_cityType];
    
    _cityBelong = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
    _cityBelong.positionType = CCPositionTypeNormalized;
    _cityBelong.anchorPoint = ccp(0,0);
    _cityBelong.position = ccp(0.865, 0.86);
    [self addChild:_cityBelong];
    
    CCLabelTTF *merchantValue = [CCLabelTTF labelWithString:getLocalString(@"MerchantValue") fontName:nil fontSize:10];
    merchantValue.positionType = CCPositionTypeNormalized;
    merchantValue.anchorPoint = ccp(0,0);
    merchantValue.position = ccp(0.8, 0.805);
    [self addChild:merchantValue];
    
    CCLabelTTF *weaponValue = [CCLabelTTF labelWithString:getLocalString(@"WeaponValue") fontName:nil fontSize:10];
    weaponValue.positionType = CCPositionTypeNormalized;
    weaponValue.anchorPoint = ccp(0,0);
    weaponValue.position = ccp(0.8, 0.745);
    [self addChild:weaponValue];
    
    _labWeaponValue = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:12];
    _labWeaponValue.positionType = CCPositionTypeNormalized;
    _labWeaponValue.anchorPoint = ccp(0,0);
    _labWeaponValue.position = ccp(0.9, 0.745);
    [self addChild:_labWeaponValue];
    
    _labMerchantValue = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:12];
    _labMerchantValue.positionType = CCPositionTypeNormalized;
    _labMerchantValue.anchorPoint = ccp(0,0);
    _labMerchantValue.position = ccp(0.9, 0.795);
    [self addChild:_labMerchantValue];
    
    _cityState = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
    _cityState.positionType = CCPositionTypeNormalized;
    _cityState.anchorPoint = ccp(0.5,0);
    _cityState.position = ccp(0.88, 0.696);
    [self addChild:_cityState];
    
    
    CCLabelTTF *labGoodsTag = [CCLabelTTF labelWithString:getLocalString(@"cityGoods") fontName:nil fontSize:10];
    labGoodsTag.positionType = CCPositionTypeNormalized;
    labGoodsTag.anchorPoint = ccp(0,0);
    labGoodsTag.position = ccp(0.8, 0.34);
    [self addChild:labGoodsTag];
    
    _labCityGoodsArray = [NSMutableArray new];
    for (int i = 0; i < 5; ++i) {
        CCLabelTTF *labGoods = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
        labGoods.positionType = CCPositionTypeNormalized;
        labGoods.anchorPoint = ccp(0,0);
        labGoods.position = ccp(0.8, 0.30 - i * 0.053);
        [self addChild:labGoods];
        [_labCityGoodsArray addObject:labGoods];
    }
    
    _cityBuildingGroup = [[CityBuildingGroup alloc] init];
    _cityBuildingGroup.delegate = self;
    [self addChild:_cityBuildingGroup];
    
    CitySystemBar *bar = [[CitySystemBar alloc] init];
    [self addChild:bar];
    
    _labDate = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
    _labDate.anchorPoint = ccp(1, 0.5);
    _labDate.positionType = CCPositionTypeNormalized;
    _labDate.position = ccp(0.98, 0.05);
    [self addChild:_labDate];
    
    _labGuildNameArray = [NSMutableArray new];
    _labOccupationArray = [NSMutableArray new];
    for (int i = 0; i < 3; ++i) {
        CCLabelTTF *labelOccupation = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:10];
        labelOccupation.positionType = CCPositionTypeNormalized;
        labelOccupation.anchorPoint = ccp(1,0);
        labelOccupation.position = ccp(0.96,0.598 - i * 0.1);
        [self addChild:labelOccupation];
        [_labOccupationArray addObject:labelOccupation];
        
        CCLabelTTF *labelGuildName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:9];
        labelGuildName.positionType = CCPositionTypeNormalized;
        labelGuildName.anchorPoint = ccp(0, 0.5);
        labelGuildName.position = ccp(0.8,0.665 - i * 0.1);
        [self addChild:labelGuildName];
        [_labGuildNameArray addObject:labelGuildName];
    }
    
    [[GameDataManager sharedGameData] addTimeUpdateClass:self];
    [[GameDataManager sharedGameData] addOccupationUpdateClass:self];
    [[GameDataManager sharedGameData] addCityChangeClass:self];
    return self;
}

-(void)updateDate
{
    _labDate.string = [[GameDataManager sharedGameData] getDateStringWithYear:YES];
    //如果有对话，使用
    if (self.scene == [CCDirector sharedDirector].runningScene) {
        NSMutableArray *dialogList = [GameDataManager sharedGameData].dialogList;
        if (dialogList.count > 0) {
            GameDialogData *dialogData = [dialogList objectAtIndex:0];
            [dialogList removeObjectAtIndex:0];
            DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:nil];
            [dialogPanel setDialogWithPhotoNo:dialogData.portrait npcName:dialogData.npcName text:dialogData.text];
            [self addChild:dialogPanel];
            
        }
    }
}

-(void)changeCity:(NSString *)cityNo
{
    _cityNo = cityNo;
    _cityData = [[[DataManager sharedDataManager] getCityDic] getCityById:cityNo];
    GameCityData *cityData = [[ GameDataManager sharedGameData].cityDic objectForKey:cityNo];
    [self playMusic];
    _cityName.string = getLocalStringByString(@"city_name_", cityNo);
    [_cityBg setSpriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"Town_%d.png", _cityData.cityBackground]]];
    _cityType.string = getLocalStringByInt(@"city_type_",_cityData.cityType);
    _cityBelong.string = getLocalStringByInt(@"city_country_", _cityData.country);
    _labWeaponValue.string = [NSString stringWithFormat:@"%d", cityData.milltaryValue];
    _labMerchantValue.string = [@(cityData.commerceValue) stringValue];
    _cityState.string = getLocalStringByInt(@"city_state_", cityData.cityState);
    
    NSUInteger i = 0;
    for (NSString *goodsId in cityData.goodsDict) {
        CCLabelTTF *labGoods = [_labCityGoodsArray objectAtIndex:i++];
        labGoods.string = getLocalStringByString(@"goods_name_", goodsId);
    }
    for (; i < 5; ++i) {
        CCLabelTTF *labGoods = [_labCityGoodsArray objectAtIndex:i];
        labGoods.string = @"";
    }
    [_cityBuildingGroup setCityNo:_cityNo];
    [self occupationUpdateCityNo:_cityNo data:cityData.guildOccupation];
    [self updateDate];
    [self checkStory:@"0"];
}

-(void)checkStory:(NSString *)buildingId
{
    // check trigger condition
    NSString *storyId = [GameStoryTriggerManager searchStory:_cityNo buildingId:buildingId];
    if (storyId != nil) {
        CGStoryScene *cgScene = [[CGStoryScene alloc] initWithStoryId:storyId];
        cgScene.delegate = self;
        [[CCDirector sharedDirector] pushScene:cgScene];
    }
}

-(void)playMusic
{
    [GameDataManager sharedGameData].currentMusic = [NSString stringWithFormat:@"city_%d.mp3", _cityData.musicId];
}

-(void)gotoBuildingNo:(NSString *)buildingNo
{
    [_cityBuildingGroup gotoBuildingNo:buildingNo];
}

-(void)storyEnd
{
    [self playMusic];
}

-(void)occupationUpdateCityNo:(NSString *)cityNo data:(NSDictionary *)data
{
    if ([_cityNo isEqualToString:cityNo]) {
        NSArray *myArray;
        myArray = [data keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        for (int i = 0; i < myArray.count; ++i) {
            NSString *guildNo = myArray[i];
            CCLabelTTF *labelGuild = _labGuildNameArray[i];
            labelGuild.string = getLocalStringByString(@"guild_name_", guildNo);
            CCLabelTTF *labelOccupation = _labOccupationArray[i];
            labelOccupation.string =[NSString stringWithFormat:@"%@%%",[data objectForKey:guildNo]];
        }
        for (NSUInteger i = myArray.count; i < 3; ++i) {
            CCLabelTTF *labelGuild = _labGuildNameArray[i];
            labelGuild.string = @"";
            CCLabelTTF *labelOccupation = _labOccupationArray[i];
            labelOccupation.string = @"";
        }
    }
}

@end
