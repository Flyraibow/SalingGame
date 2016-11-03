//
//  CGStoryScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@class CityScene;
@interface CGStoryScene : CCScene

@property (nonatomic, weak) CityScene *cityScene;

-(instancetype)initWithStoryId:(NSString *)storyId;

@end
