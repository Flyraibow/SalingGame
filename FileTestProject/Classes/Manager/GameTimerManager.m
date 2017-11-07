//
//  GameTimerManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameTimerManager.h"
#import "CCDirector_Private.h"

static GameTimerManager *_sharedTimerManager;

@interface GameTimerManager() <CCSchedulerTarget>

@end

@implementation GameTimerManager
{
    __weak CCScheduler *_scheduler;
    NSMutableArray *_blockList;
    NSMutableArray *_intervalList;
    BOOL _paused;
}

@synthesize paused = _paused;

+ (void)clearCurrentGame
{
  _sharedTimerManager = nil;
}

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
        _blockList = [NSMutableArray new];
        _intervalList = [NSMutableArray new];
        _scheduler = [[CCDirector sharedDirector] scheduler];
        [_scheduler scheduleTarget:self];
        self.paused = NO;
    }
    return self;
}

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    BOOL p = paused || _intervalList.count == 0;
    [_scheduler setPaused:p target:self];
}

- (BOOL)paused
{
    return [_scheduler isTargetPaused:self];
}

- (NSInteger)priority
{
    return 1;
}

- (void)update:(CCTime)delta
{
    if (_intervalList.count) {
        for (NSInteger i = _intervalList.count - 1; i >= 0 ; --i) {
            CCTime t = [_intervalList[i] doubleValue];
            t -= delta;
            if (t <= 0) {
                [_intervalList removeObjectAtIndex:i];
                void(^block)() = _blockList[i];
                block();
                [_blockList removeObjectAtIndex:i];
            } else {
                _intervalList[i] = @(t);
            }
        }
        if (_intervalList.count == 0) {
            self.paused = _paused;
        }
    }
    
}

- (void)addBlock:(void(^)())complete withInterval:(CCTime)interval
{
    [_blockList addObject:complete];
    [_intervalList addObject:@(interval)];
    if (_intervalList.count == 1) {
        self.paused = _paused;
    }
}

@end
