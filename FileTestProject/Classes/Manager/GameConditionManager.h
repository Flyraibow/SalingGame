//
//  GameConditionManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameConditionManager : NSObject

+ (GameConditionManager *)sharedConditionManager;

- (BOOL)checkCondition:(NSString *)conditionId;

- (BOOL)checkConditions:(NSString *)conditions;

@end
