//
//  CGStoryScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@protocol CGStorySceneDelegate <NSObject>

-(void)storyEnd;

-(void)gotoBuildingNo:(NSString *)buildingNo;

@end

@interface CGStoryScene : CCScene

@property (nonatomic) id<CGStorySceneDelegate> delegate;

-(instancetype)initWithStoryId:(NSString *)storyId;

@end
