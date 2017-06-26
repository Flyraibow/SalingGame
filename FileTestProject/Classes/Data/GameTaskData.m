//
//  TaskData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameTaskData.h"
#import "DataManager.h"
#import "LocalString.h"
#import "GameValueManager.h"
#import "GameCityData.h"
#import "GameDataManager.h"

static NSString* const GameTaskStyleNo = @"GameTaskStyleNo";
static NSString* const GameTaskDeposit = @"GameTaskDeposit";
static NSString* const GameTaskProfit = @"GameTaskProfit";

typedef enum : NSUInteger {
    TaskTypeNone,
    TaskTypeBuyGoodsNear        = 1,
    TaskTypeBuyGoodsFar         = 2,
    TaskTypeShipGoodsNear       = 3,
    TaskTypeShipGoodsFar        = 4,
    TaskTypeShipLetterNear      = 5,
    TaskTypeShipLetterFar       = 6,
    TaskTypeBuyItemNear         = 7,
    TaskTypeBuyItemFar          = 8,
    TaskTypeDefeatPirateNear    = 9,
    TaskTypeDefeatPirateFar     = 10,
    TaskTypeGetRecommendLetter  = 11,
    TaskTypeMakePopular         = 12,
    TaskTypeShipItemNear        = 13,
    TaskTypeShipItemFar         = 14,
} TaskType;

@implementation GameTaskData
{
    __weak TaskData *_taskData;
    int _num;
    NSString *_goodsId;
    NSString *_destCityId;
    NSString *_startCityId;
}

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId
{
    if (self = [super init]) {
        _taskData = taskData;
        _cityId = cityId;
        GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityId];
        // TODO: generate the randon item, including item, goods, profit and profit, etc.
        TaskType taskStyle = [taskData.taskStyleId intValue];
        GameCityData *destCity;
        switch (taskStyle) {
            case TaskTypeBuyGoodsNear:
            {
                destCity = [[GameDataManager sharedGameData] randomCityFromCity:cityData
                                                                      condition:(CityDifferentGoods | CityNear)];
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
                break;
            }
            case TaskTypeBuyGoodsFar:
            {
                destCity = [[GameDataManager sharedGameData] randomCityFromCity:cityData
                                                                      condition:(CityDifferentGoods | CityFaraway)];
                _num = arc4random() % 10 + 5;
                break;
            }
            default:
                break;
        }
        _destCityId = destCity.cityNo;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _deposit = [aDecoder decodeIntegerForKey:GameTaskDeposit];
        _profit = [aDecoder decodeIntegerForKey:GameTaskProfit];
        NSString *styleId = [aDecoder decodeObjectForKey:GameTaskStyleNo];
        _taskData = [[DataManager sharedDataManager].getTaskDic getTaskById:styleId];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_taskData.taskStyleId forKey:GameTaskStyleNo];
    [aCoder encodeInteger:_deposit forKey:GameTaskDeposit];
    [aCoder encodeInteger:_profit forKey:GameTaskProfit];
}

-(NSInteger)breakUpFee
{
    // 违约费
    return _deposit * 2 + _profit / 2;
}

-(NSString *)description
{
    return [[GameValueManager sharedValueManager] replaceTextWithDefaultRegex:getLocalStringByInt(@"task_description_", _taskData.taskDescriptionId)];
}

-(NSString *)title
{
    return getLocalStringByInt(@"task_title_", _taskData.taskTitleId);
}

-(NSString *)buttonTitle
{
    return [NSString stringWithFormat:@"%@  %zd", self.title, self.profit];
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
