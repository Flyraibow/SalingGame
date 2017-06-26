//
//  TaskData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskData.h"
#import "BaseData.h"

@interface GameTaskData : BaseData <NSCoding>

@property (nonatomic, readonly) NSInteger deposit;
@property (nonatomic, readonly) NSInteger profit;
@property (nonatomic, readonly) NSInteger breakUpFee;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *buttonTitle;
@property (nonatomic, readonly) NSString *cityId;

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId;

@end
