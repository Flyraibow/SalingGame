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

static NSString* const GameTaskBuyGoodsDataProfit = @"GameTaskBuyGoodsDataProfit";
static NSString* const GameTaskBuyGoodsDataGoodsId = @"GameTaskBuyGoodsDataGoodsId";
static NSString* const GameTaskBuyGoodsDataDestCityId = @"GameTaskBuyGoodsDataDestCityId";
static NSString* const GameTaskBuyGoodsDataNum = @"GameTaskBuyGoodsDataNum";

@implementation GameTaskBuyGoodsData
{
  NSInteger _num;
  NSString *_goodsId;
  NSString *_destCityId;
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
      if (goodsId != nil && [cityData.goodsDict objectForKey:goodsId] == nil) {
        [goodsList addObject:goodsId];
      }
    }
    NSAssert(goodsList.count > 0, @"Must contain goods doesn't sell here");
    _goodsId = goodsList[arc4random() % goodsList.count];
    NSAssert(_goodsId.length > 0, @"GoodsId cannot be empty, city Name: %@", getCityName(destCity.cityNo));
    _destCityId = cityId;
    
    // calculate the profit
    _profit = [destCity getSalePriceForGoodsId:_goodsId level:1] * _num * taskData.profitValue / 100;
  }
  return self;
}

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId
{
  return [self initWithTaskData:taskData belongCity:cityId isFar:NO];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    _profit = [aDecoder decodeIntegerForKey:GameTaskBuyGoodsDataProfit];
    _num = [aDecoder decodeIntegerForKey:GameTaskBuyGoodsDataNum];
    _goodsId = [aDecoder decodeObjectForKey:GameTaskBuyGoodsDataGoodsId];
    _destCityId = [aDecoder decodeObjectForKey:GameTaskBuyGoodsDataDestCityId];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [super encodeWithCoder:aCoder];
  [aCoder encodeInteger:_profit forKey:GameTaskBuyGoodsDataProfit];
  [aCoder encodeInteger:_num forKey:GameTaskBuyGoodsDataNum];
  [aCoder encodeObject:_goodsId forKey:GameTaskBuyGoodsDataGoodsId];
  [aCoder encodeObject:_destCityId forKey:GameTaskBuyGoodsDataDestCityId];
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

