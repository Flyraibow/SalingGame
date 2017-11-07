//
//  GameConditionManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBaseManager.h"

@interface GameConditionManager : NSObject <GameManagerProtocol>

+ (GameConditionManager *)sharedConditionManager;

- (BOOL)checkCondition:(NSString *)conditionId;

- (BOOL)checkConditions:(NSString *)conditions;

@end
