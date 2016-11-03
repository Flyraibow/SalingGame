//
//  GameStoryTriggerManager.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/28/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface GameStoryTriggerManager : NSObject

+(void)searchAndStartStory:(NSString *)cityId buildingId:(NSString *)buildingId;

+(NSString *)searchStory:(NSString *)cityId buildingId:(NSString *)buildingId;

@end
