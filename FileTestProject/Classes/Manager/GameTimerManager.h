//
//  GameTimerManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCScheduler.h"

@interface GameTimerManager : CCScheduler

+ (GameTimerManager *)sharedTimerManager;

@end
