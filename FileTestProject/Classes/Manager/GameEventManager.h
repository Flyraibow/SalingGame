//
//  GameEventManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 10/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCScene;
@interface GameEventManager : NSObject

+ (GameEventManager *)sharedEventManager;

- (void)startEventId:(NSString *)eventId;

- (void)startEventId:(NSString *)eventId withScene:(CCScene *)scene;

@end
