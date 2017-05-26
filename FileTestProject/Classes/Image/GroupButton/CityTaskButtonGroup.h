//
//  CityTaskButtonGroup.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/23/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "BaseButtonGroup.h"

@class GameTaskData;
@interface CityTaskButtonGroup : BaseButtonGroup

- (instancetype)initWithTasks:(NSArray<GameTaskData *> *)tasks;

@end
