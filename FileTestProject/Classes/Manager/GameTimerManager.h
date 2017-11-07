//
//  GameTimerManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCScheduler.h"
#import "GameBaseManager.h"

@interface GameTimerManager : NSObject <GameManagerProtocol>

+ (GameTimerManager *)sharedTimerManager;

/** Whether the timer is paused. */
@property(nonatomic, assign) BOOL paused;

- (void)addBlock:(void(^)())complete withInterval:(CCTime)interval;

@end
