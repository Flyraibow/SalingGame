//
//  GameTaskBuyGoodsData.m
//  FileTestProject
//
//  Created by Yujie Liu on 10/23/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "GameTaskBuyGoodsData.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "GameValueManager.h"
#import "LocalString.h"

@implementation GameTaskBuyGoodsData
{
  int _num;
  NSString *_goodsId;
  NSString *_destCityId;
  NSString *_startCityId;
}

@synthesize profit = _profit;

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId isFar:(BOOL)isFar
{
  if (self = [super initWithTaskData:taskData belongCity:cityId]) {
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityId];
    CitySearchCondition cityCondition = isFar ? CityFaraway : CityNear;
    GameCityData *destCity = [[GameDataManager sharedGameData] randomCityFromCity:cityData
                                                                        condition:(CityDifferentGoods | cityCondition)];
    NSAssert(destCity, @"Must contain valid dest City (Game Task)");
    _num = arc4random() % 5 + 2;
    NSMutableArray *goodsList = [NSMutableArray new];
    for (NSString *goodsId in destCity.goodsDict) {
      if ([cityData.goodsDict objectForKey:goodsId] == nil) {
        [goodsList addObject:goodsId];
      }
    }
    NSAssert(goodsList.count > 0, @"Must contain goods doesn't sell here");
    _goodsId = goodsList[arc4random() % goodsList.count];
    _destCityId = destCity.cityNo;
    
    // calculate the profit
    _profit = [destCity getSalePriceForGoodsId:_goodsId level:1] * _num * taskData.profitValue / 100;
  }
  return self;
}

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId
{
  return [self initWithTaskData:taskData belongCity:cityId isFar:NO];
}

-(NSString *)num
{
  return [@(_num) stringValue];
}

-(NSString *)goods
{
  return getGoodsName(_goodsId);
}

-(NSString *)destCity
{
  return getCityName(_destCityId);
}

@end

