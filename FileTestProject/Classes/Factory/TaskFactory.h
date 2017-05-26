//
//  TaskFactory.h
//  FileTestProject
//
//  Created by Yujie Liu on 5/18/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameTaskData;
@class GameCityData;
@interface TaskFactory : NSObject

+(NSArray<GameTaskData *> *)generateTask:(int)taskNumber forCity:(GameCityData *)cityData;

@end
