//
//  GameDataManager.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameData.h"

@interface GameDataManager : NSObject

+(GameData *)sharedGameData;

+(void)saveWithIndex:(int)index;

+(void)loadWithIndex:(int)index;

@end
