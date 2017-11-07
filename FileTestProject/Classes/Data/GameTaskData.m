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

#import "GameTaskBuyGoodsData.h"

static NSString* const GameTaskStyleNo = @"GameTaskStyleNo";
static NSString* const GameTaskDeposit = @"GameTaskDeposit";
static NSString* const GameTaskProfit = @"GameTaskProfit";
static NSString* const GameTaskCityId = @"GameTaskCityId";

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

+ (instancetype)taskWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId
{
  TaskType taskStyle = [taskData.taskStyleId intValue];
  GameTaskData *gameTaskData = nil;
  switch (taskStyle) {
    case TaskTypeBuyGoodsNear:
    {
      gameTaskData = [[GameTaskBuyGoodsData alloc] initWithTaskData:taskData belongCity:cityId isFar:NO];
      break;
    }
    case TaskTypeBuyGoodsFar:
    {
      gameTaskData = [[GameTaskBuyGoodsData alloc] initWithTaskData:taskData belongCity:cityId isFar:YES];
      break;
    }
    default:
      gameTaskData = [[GameTaskData alloc] initWithTaskData:taskData belongCity:cityId];
      break;
  }
  return gameTaskData;
}

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId
{
  if (self = [super init]) {
    _taskData = taskData;
    _cityId = cityId;
    if (taskData.profitType == 0) {
      _profit = taskData.profitValue;
    }
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
    _cityId = [aDecoder decodeObjectForKey:GameTaskCityId];
  }
  return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:_taskData.taskStyleId forKey:GameTaskStyleNo];
  [aCoder encodeInteger:_deposit forKey:GameTaskDeposit];
  [aCoder encodeInteger:_profit forKey:GameTaskProfit];
  [aCoder encodeObject:_cityId forKey:GameTaskCityId];
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

-(NSInteger)breakUpFee
{
  // 违约费
  return _deposit * 2 + _profit / 2;
}

@end

