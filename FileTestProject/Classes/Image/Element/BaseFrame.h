//
//  BaseFrame.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface BaseFrame : CCSprite

@property (nonatomic, weak) CCSprite *hiddenPanel;

-(instancetype)initWithNodeColor:(CCNodeColor *)nodeColor;

@end
