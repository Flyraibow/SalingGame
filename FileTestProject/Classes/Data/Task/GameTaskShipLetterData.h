//
//  GameTaskShipLetterData.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/8/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "GameTaskData.h"

@interface GameTaskShipLetterData : GameTaskData

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId isFar:(BOOL)isFar;

@end
