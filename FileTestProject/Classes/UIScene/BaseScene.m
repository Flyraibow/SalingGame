//
//  BaseScene.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseScene.h"
//#import "GameDataManager.h"

@implementation BaseScene


+ (instancetype)sceneWithParameters:(NSString *)parameters
{
    NSMutableArray *paraList = [[parameters componentsSeparatedByString:@";"] mutableCopy];
    NSString *sceneClassName = paraList[0];
    [paraList removeObjectsInRange:NSMakeRange(0, 1)];
    Class cls = NSClassFromString(sceneClassName);
    BaseScene *basePanel = [(BaseScene *)[cls alloc] initWithDataList:paraList];
    NSAssert(basePanel, @"Windows Scene is nil : %@", sceneClassName);
    return basePanel;
}

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
    if (self = [self init]) {
    }
    return self;
}

@end
