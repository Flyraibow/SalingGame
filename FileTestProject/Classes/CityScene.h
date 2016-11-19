//
//  CityScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 1/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface CityScene : CCScene

-(void)storyEnd;

-(void)gotoBuildingNo:(NSString *)buildingNo;

-(void)checkStory:(NSString *)buildingId;

-(void)changeCity:(NSString *)cityNo;
@end
