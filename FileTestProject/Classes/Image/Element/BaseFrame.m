//
//  BaseFrame.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseFrame.h"

@implementation BaseFrame


-(instancetype)initWithNodeColor:(CCNodeColor *)nodeColor
{
    if (self = [super init]) {
        CGSize contentSize = [[CCDirector sharedDirector] viewSize];
        self.contentSize = contentSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        
        if (nodeColor != nil) {
            [self addChild:nodeColor];
        }
    }
    return self;
}

-(instancetype)init
{
    if (self = [self initWithNodeColor:nil]) {
    }
    return self;
}

- (void)setHiddenPanel:(CCSprite *)hiddenPanel
{
    if (_hiddenPanel != hiddenPanel) {
        if (_hiddenPanel) {
            _hiddenPanel.visible = YES;
        }
        if (hiddenPanel) {
            hiddenPanel.visible = NO;
        }
        _hiddenPanel = hiddenPanel;
    }
}

- (void)removeFromParent
{
    [super removeFromParent];
    if (self.hiddenPanel) {
        self.hiddenPanel.visible = YES;
    }
}

@end
