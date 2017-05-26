//
//  TaskFactory.m
//  FileTestProject
//
//  Created by Yujie Liu on 5/18/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "TaskFactory.h"
#import "DataManager.h"
#import "GameTaskData.h"
#import "GameConditionManager.h"
#import "GameCityData.h"

@implementation TaskFactory

+(NSArray<GameTaskData *> *)generateTask:(int)taskNumber forCity:(GameCityData *)cityData
{
    NSMutableArray *array = [NSMutableArray new];
    // TODO:
    TaskDic *taskDic = [DataManager sharedDataManager].getTaskDic;
    NSDictionary *dict= [taskDic getDictionary];
    NSInteger totalPossiblity = 0;
    NSMutableArray *taskList = [NSMutableArray new];
    NSMutableArray *possibleList = [NSMutableArray new];
    for (NSString *taskId in dict) {
        TaskData *taskData = dict[taskId];
        if (taskData.priority > 0) {
            if ([[GameConditionManager sharedConditionManager] checkConditions:taskData.condition]) {
                if (taskData.priority >= 100) {
                    GameTaskData *gameTaskData = [[GameTaskData alloc] initWithTaskData:taskData belongCity:cityData.cityNo];
                    [array addObject:gameTaskData];
                    taskNumber--;
                } else {
                    totalPossiblity += taskData.priority;
                    [taskList addObject:taskData];
                    [possibleList addObject:@(totalPossiblity)];
                }
            }
        }
    }
    while (taskList.count > 0 && taskNumber > 0) {
        int random = arc4random() % totalPossiblity;
        int a = 0;
        int b = (int)taskList.count - 1;
        while (a < b) {
            int mid = (a + b) / 2;
            if ([possibleList[mid] integerValue] > random) {
                if (mid == 0 || [possibleList[mid - 1] integerValue] <= random) {
                    b = a;
                    break;
                } else {
                    b = mid;
                }
            } else {
                a = mid + 1;
            }
        }
        if (a == b) {
            TaskData *taskData = taskList[a];
            GameTaskData *gameTaskData = [[GameTaskData alloc] initWithTaskData:taskData belongCity:cityData.cityNo];
            [array addObject:gameTaskData];
            [taskList removeObjectAtIndex:a];
            [possibleList removeObjectAtIndex:a];
            taskNumber--;
            if (taskNumber > 0 && taskList.count > 0) {
                for (int i = a; i < possibleList.count; ++i) {
                    possibleList[i] = @([possibleList[i] integerValue] - taskData.priority);
                }
            } else {
                break;
            }
        }
    }
    
    return array;
}

@end
