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

static NSString* const GameTaskStyleNo = @"GameTaskStyleNo";
static NSString* const GameTaskDeposit = @"GameTaskDeposit";
static NSString* const GameTaskProfit = @"GameTaskProfit";

@implementation GameTaskData
{
    __weak TaskData *_taskData;
}

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId
{
    if (self = [super init]) {
        _taskData = taskData;
        _cityId = cityId;
        // TODO: generate the randon item, including item, goods, profit and profit, etc.
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

-(NSString *)description
{
    // TODO: it's not correct
    return getLocalStringByInt(@"task_description_", _taskData.taskDescriptionId);
}

-(NSString *)title
{
    return getLocalStringByInt(@"task_title_", _taskData.taskTitleId);
}

@end
