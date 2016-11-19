//
//  GameDataObserver.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/19/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *LISTENNING_KEY_CITY = @"LISTENNING_KEY_CITY";
static const NSString *LISTENNING_KEY_CITY_OCCUPATION = @"LISTENNING_KEY_CITY_OCCUPATION";
static const NSString *LISTENNING_KEY_MONEY = @"LISTENNING_KEY_MONEY";
static const NSString *LISTENNING_KEY_DATE = @"LISTENNING_KEY_DATE";
static const NSString *LISTENNING_KEY_EQUIP = @"LISTENNING_KEY_EQUIP";

@interface GameDataObserver : NSObject

+ (GameDataObserver *)sharedObserver;

- (void)addListenerForKey:(const NSString *)key target:(id)target selector:(SEL)selector;
- (void)removeListenerForKey:(const NSString *)key target:(id)target;
- (void)removeAllListenersForTarget:(id)target;
- (void)sendListenerForKey:(const NSString *)key data:(id)data;

@end
