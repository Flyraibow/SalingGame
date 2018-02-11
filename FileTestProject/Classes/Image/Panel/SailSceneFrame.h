//
//  SailSceneFrame.h
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
  SailSceneFrameNormal,
  SailSceneFrameFight,
} SailSceneFrameType;

@interface SailSceneFrame : CCSprite

-(instancetype)initWithSailSceneFrameType:(SailSceneFrameType)type;

@end
