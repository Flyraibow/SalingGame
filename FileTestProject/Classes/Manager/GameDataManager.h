//
//  GameDataManager.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameData.h"

@interface GameProgressData : NSObject

- (NSString *)descriptionForIndex:(int)index;

@end

@interface GameDataManager : NSObject

+(GameData *)sharedGameData;

+(void)clearCurrentGame;

+(GameProgressData *)sharedProgressData;

+(void)saveWithIndex:(int)index;

+(void)loadWithIndex:(int)index;

+(BOOL)isInitialed;

@end
