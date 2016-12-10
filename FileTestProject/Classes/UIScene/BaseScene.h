//
//  BaseScene.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCScene.h"

@interface BaseScene : CCScene

+ (instancetype)sceneWithParameters:(NSString *)parameters;

- (instancetype)initWithDataList:(NSArray *)dataList;

@property (copy) void (^completionBlockWithEventId)(NSString *);

@end
