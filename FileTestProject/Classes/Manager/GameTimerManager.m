//
//  GameTimerManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameTimerManager.h"

static GameTimerManager *_sharedTimerManager;

@implementation GameTimerManager

+ (GameTimerManager *)sharedTimerManager
{
    if (!_sharedTimerManager) {
        _sharedTimerManager = [[GameTimerManager alloc] init];
    }
    return _sharedTimerManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)update:(CCTime)dt
{
    NSLog(@" =====dt======");
}

@end
