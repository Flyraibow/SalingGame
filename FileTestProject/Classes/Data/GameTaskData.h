//
//  TaskData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskData.h"

@interface GameTaskData : NSObject <NSCoding>

@property (nonatomic, readonly) NSInteger deposit;
@property (nonatomic, readonly) NSInteger profit;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *cityId;

- (instancetype)initWithTaskData:(TaskData *)taskData belongCity:(NSString *)cityId;

@end
