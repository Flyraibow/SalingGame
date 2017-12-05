//
//  GameTaskShipLetterData.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/8/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "GameTaskShipLetterData.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "GameRouteData.h"
#import "LocalString.h"

@implementation GameTaskShipLetterData
{
  NSString *_destCityId;
}

@synthesize profit = _profit;

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId isFar:(BOOL)isFar
{
  if (self = [super initWithTaskData:taskData belongCity:cityId]) {
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityId];
    CitySearchCondition distanceCondition = isFar ? CityFaraway : CityNear;
    GameCityData *destCity = [[GameDataManager sharedGameData] randomCityFromCity:cityData
                                                                        condition:(CityWithShop | distanceCondition)];
    _destCityId = destCity.cityNo;
    NSAssert(_destCityId != nil, @"Destiny city cannot be nil");
    NSArray *cityList = [GameRouteData searchRoutes:cityId city2:_destCityId];
    
    // calculate profit
    _profit = (cityList.count / 5 + 1) * 1000;
  }
  return self;
}

-(NSString *)destCity
{
  return getCityLabel(_destCityId);
}

@end
