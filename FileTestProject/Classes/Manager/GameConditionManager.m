//
//  GameConditionManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameConditionManager.h"
#import "DataManager.h"

static GameConditionManager *_sharedConditionManager;

@implementation GameConditionManager
{
    NSDictionary *_conditionDictionary;
}

+ (GameConditionManager *)sharedConditionManager
{
    if (!_sharedConditionManager) {
        _sharedConditionManager = [[GameConditionManager alloc] init];
    }
    return _sharedConditionManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _conditionDictionary = [[DataManager sharedDataManager].getConditionDic getDictionary];
    }
    return self;
}

- (BOOL)checkConditions:(NSString *)conditions
{
    NSArray *conditionList = [conditions componentsSeparatedByString:@";"];
    for (NSString *str in conditionList) {
        if (str.length > 0 && ![self checkCondition:str]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkCondition:(NSString *)conditionId
{
    return conditionId.length == 0;
}

@end
