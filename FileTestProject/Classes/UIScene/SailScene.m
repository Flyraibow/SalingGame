//
//  SailScene.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "SailScene.h"
#import "SailSceneFrame.h"

@implementation SailScene

-(instancetype)initWithDataList:(NSArray *)dataList
{
  return [self init];
}

-(instancetype)init
{
  if (self = [super init]) {
    SailSceneFrame *sailSceneFrame = [[SailSceneFrame alloc] initWithSailSceneFrameType:SailSceneFrameNormal];
    sailSceneFrame.positionType = CCPositionTypeNormalized;
    sailSceneFrame.position = ccp(0.5, 0.5);
    sailSceneFrame.scale =  self.scene.contentSize.height / sailSceneFrame.contentSize.height;
    [self addChild:sailSceneFrame];
  }
  return self;
}

@end
