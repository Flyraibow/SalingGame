//
//  GameEventManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 10/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameEventManager.h"
#import "DataManager.h"
#import "BaseButtonGroup.h"
#import "CityScene.h"
#import "GamePanelManager.h"
#import "GameConditionManager.h"
#import "GameDataManager.h"

static GameEventManager *_sharedEventManager;

@implementation GameEventManager
{
    NSDictionary *_eventDictionary;
    NSMutableArray *_viewStack;
    NSArray *_eventList;
    NSInteger _currentEventIndex;
    NSArray *_dialogList;
    NSInteger _currentDialogIndex;
    NSInteger _currentDays;
    NSInteger _totalDays;
    NSArray *_tempDialogContent;
}

+ (GameEventManager *)sharedEventManager
{
    if (!_sharedEventManager) {
        _sharedEventManager = [[GameEventManager alloc] init];
    }
    return _sharedEventManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _eventDictionary = [[DataManager sharedDataManager].getEventActionDic getDictionary];
        _viewStack = [NSMutableArray new];
    }
    return self;
}

- (void)startEventId:(NSString *)eventId withScene:(CCScene *)scene
{
    EventActionData *eventData = [_eventDictionary objectForKey:eventId];
    if (eventData) {
        if ([eventData.eventType isEqualToString:@"close"]) {
            if (_viewStack.count > 0) {
                CCNode *node = [_viewStack lastObject];
                [node removeFromParent];
                [_viewStack removeLastObject];
                if (_viewStack.count == 0 && [[CCDirector sharedDirector].runningScene isKindOfClass:[CityScene class]]) {
                    CCScene *scene = [CCDirector sharedDirector].runningScene;
                    if ([scene isKindOfClass:[CityScene class]]) {
                        [(CityScene *)scene checkStory:@"0"];
                    }
                }
                [self _startEventList];
            }
        } else if ([eventData.eventType isEqualToString:@"selectlist"]) {
            BaseButtonGroup *buttonGroup = [[BaseButtonGroup alloc] initWithEventActionData:eventData];
            buttonGroup.baseScene = scene;
            [_viewStack addObject:buttonGroup];
            [scene addChild:buttonGroup];
        } else if ([eventData.eventType isEqualToString:@"dialog"]) {
            _dialogList = [eventData.parameter componentsSeparatedByString:@";"];
            _currentDialogIndex = 0;
            [self _startEventList];
            
        } else if ([eventData.eventType isEqualToString:@"eventList"]) {
            _eventList = [eventData.parameter componentsSeparatedByString:@";"];
            _currentEventIndex = 0;
            [self _startEventList];
        } else if ([eventData.eventType isEqualToString:@"window"]) {
            NSMutableArray *paraList = [[eventData.parameter componentsSeparatedByString:@";"] mutableCopy];
            NSString *spriteClassName = paraList[0];
            [paraList removeObjectAtIndex:0];
            Class cls = NSClassFromString(spriteClassName);
            BasePanel *sprite = [[cls alloc] initWithArray:paraList];
            sprite.completionBlockWithEventId = ^(NSString *eventId) {
                [self startEventId:eventId withScene:scene];
            };
            [scene addChild:sprite];
        } else if ([eventData.eventType isEqualToString:@"condition"]) {
            NSArray *array = [eventData.parameter componentsSeparatedByString:@";"];
            if (array.count > 0) {
                if ([[GameConditionManager sharedConditionManager] checkCondition:eventData.eventId]) {
                    [self startEventId:array[0] withScene:scene];
                } else if (array.count > 1) {
                    [self startEventId:array[1] withScene:scene];
                }
            }
        } else if ([eventData.eventType isEqualToString:@"wait"]) {
            _totalDays = [eventData.parameter integerValue];
            _currentDays = 0;
            [self _waitADay];
        }
    } else {
        _tempDialogContent = @[eventId];
        [self startEventId:@"NIY" withScene:scene];
    }
}

- (void)startEventId:(NSString *)eventId
{
    CCScene *scene = [CCDirector sharedDirector].runningScene;
    [self startEventId:eventId withScene:scene];
}

- (void)_waitADay
{
    if (_currentDays < _totalDays) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _currentDays++;
            [[GameDataManager sharedGameData] spendOneDay];
            [self _waitADay];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _startEventList];
        });
    }
}

- (void)_startEventList
{
    if (_currentDialogIndex < _dialogList.count) {
        NSString *dialogId = _dialogList[_currentDialogIndex++];
        DialogPanel *dialog = [GamePanelManager sharedDialogPanelAboveSprite:[_viewStack lastObject] hidden:YES];
        [dialog setDefaultDialog:dialogId arguments:_tempDialogContent];
        [dialog addConfirmHandler:^{
            _tempDialogContent = nil;
            [self _startEventList];
        }];
    } else if (_currentEventIndex < _eventList.count) {
        [self startEventId:_eventList[_currentEventIndex++]];
    } else {
        _currentEventIndex = 0;
        _eventList = nil;
    }
}

@end
