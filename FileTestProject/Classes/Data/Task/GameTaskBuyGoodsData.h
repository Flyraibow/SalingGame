//
//  GameTaskBuyGoodsData.h
//  FileTestProject
//
//  Created by Yujie Liu on 10/23/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameTaskData.h"

@class GameCityData;

@interface GameTaskBuyGoodsData : GameTaskData

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId isFar:(BOOL)isFar;
- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId isFar:(BOOL)isFar differentCity:(BOOL)differentCity;

@end
