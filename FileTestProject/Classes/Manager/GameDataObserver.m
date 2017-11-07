//
//  GameDataObserver.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/19/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameDataObserver.h"

static GameDataObserver *_sharedObserver;

@implementation GameDataObserver
{
    NSMutableDictionary<const NSString *, NSMutableDictionary *> *_targetDictionary;
}

+ (void)clearCurrentGame
{
  _sharedObserver = nil;
}

+ (GameDataObserver *)sharedObserver
{
    if (!_sharedObserver) {
        _sharedObserver = [[GameDataObserver alloc] init];
    }
    return _sharedObserver;
}

- (instancetype)init
{
    if (self = [super init]) {
        _targetDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (void)addListenerForKey:(const NSString *)key target:(id)target selector:(SEL)selector
{
    NSMutableDictionary *dict = [_targetDictionary objectForKey:key];
    if (dict == nil) {
        dict = [NSMutableDictionary new];
        [_targetDictionary setObject:dict forKey:key];
    }
    [dict setObject:NSStringFromSelector(selector) forKey:target];
}

- (void)removeListenerForKey:(const NSString *)key target:(id)target
{
    NSMutableDictionary *dict = [_targetDictionary objectForKey:key];
    if (dict) {
        [dict removeObjectForKey:target];
    }
}

- (void)removeAllListenersForTarget:(id)target
{
    for (NSString *key in _targetDictionary) {
        NSMutableDictionary *dict = _targetDictionary[key];
        if (dict[target]) {
            [dict removeObjectForKey:target];
        }
    }
}

- (void)sendListenerForKey:(const NSString *)key data:(id)data
{
    NSMutableDictionary *dict = [_targetDictionary objectForKey:key];
    if (dict) {
        for (id target in dict) {
            SEL selector = NSSelectorFromString(dict[target]);
            NSAssert([target respondsToSelector:selector], @"target %@ doesn't respond to %@", target, dict[target]);
            if ([target respondsToSelector:selector]) {
                ((void (*)(id, SEL, id))[target methodForSelector:selector])(target, selector, data);
            }
        }
    }
}

@end
