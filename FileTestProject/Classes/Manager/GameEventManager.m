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

static GameEventManager *_sharedEventManager;

@implementation GameEventManager
{
    NSDictionary *_eventDictionary;
    NSMutableArray *_viewStack;
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
                    CityScene *cityScene = (CityScene *)[CCDirector sharedDirector].runningScene;
                    [cityScene checkStory:@"0"];
                }
            }
        } else if ([eventData.eventType isEqualToString:@"selectlist"]) {
            BaseButtonGroup *buttonGroup = [[BaseButtonGroup alloc] initWithEventActionData:eventData];
            buttonGroup.baseScene = scene;
            [_viewStack addObject:buttonGroup];
            [scene addChild:buttonGroup];
        }
    }
}

- (void)startEventId:(NSString *)eventId
{
    CCScene *scene = [CCDirector sharedDirector].runningScene;
    [self startEventId:eventId withScene:scene];
}

@end
