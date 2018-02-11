//
//  SailSceneFrame.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "SailSceneFrame.h"
#import "SystemButtonBarGroup.h"
#import "PressDownButton.h"
#import "CCButton+Ext.h"

@implementation SailSceneFrame
{
  CCSprite *_rudder;
  CCSprite *_anchor;
  CCButton *_anchorButton;
  PressDownButton *_canvasLeft;
  PressDownButton *_canvasRight;
}

-(instancetype)initWithSailSceneFrameType:(SailSceneFrameType)type
{
  NSString *panelFrameName = type == SailSceneFrameFight ? @"OceanFrameFight.png" : @"OceanFrameNormal.png";
  if (self = [super initWithImageNamed:panelFrameName]) {
    SystemButtonBarGroup *systemBar = [[SystemButtonBarGroup alloc] init];
    systemBar.anchorPoint = ccp(0, 0);
    systemBar.positionType = CCPositionTypePoints;
    systemBar.position = ccp(115, 450);
    [self addChild:systemBar];
    
    _rudder = [CCSprite spriteWithImageNamed:@"OceanFrameRudder.png"];
    _rudder.anchorPoint = ccp(0.5, 0.5);
    _rudder.positionType = CCPositionTypePoints;
    _rudder.position = ccp(675, 95);
    [self addChild:_rudder];
    
    _anchor = [CCSprite spriteWithImageNamed:@"OceanFrameAnchor.png"];
    _anchor.anchorPoint = ccp(0.5, 0.5);
    _anchor.positionType = CCPositionTypePoints;
    _anchor.position = ccp(675, 95);
    [self addChild:_anchor];
    _anchor.visible = NO;
    
    _anchorButton = [CCButton buttonWithImageName:@"OcFrmAnchorButton_up.png" highlightedImageName:@"OcFrmAnchorButton_down.png"];
    _anchorButton.positionType = CCPositionTypePoints;
    _anchorButton.position = ccp(690, 31);
    _anchorButton.togglesSelectedState = YES;
    [_anchorButton setTarget:self selector:@selector(clickAnchorButton)];
    [self addChild:_anchorButton];
    
    _canvasLeft = [PressDownButton buttonWithImageName:@"OcFrmCanvasLeft_up.png" highlightedImageName:@"OcFrmCanvasLeft_down.png"];
    _canvasLeft.anchorPoint = ccp(0, 0);
    _canvasLeft.positionType = CCPositionTypePoints;
    _canvasLeft.position = ccp(600, 240);
    _canvasLeft.continuousEvent = YES;
    [_canvasLeft setTarget:self selector:@selector(clickLeftCanvas)];
    [self addChild:_canvasLeft];
    
    _canvasRight = [PressDownButton buttonWithImageName:@"OcFrmCanvasRight_up.png" highlightedImageName:@"OcFrmCanvasRight_down.png"];
    _canvasRight.anchorPoint = ccp(0, 0);
    _canvasRight.positionType = CCPositionTypePoints;
    _canvasRight.position = ccp(672, 240);
    _canvasRight.continuousEvent = YES;
    [_canvasRight setTarget:self selector:@selector(clickRightCanvas)];
    [self addChild:_canvasRight];
  }
  return self;
}

- (void)clickAnchorButton
{
  _rudder.visible = !_anchorButton.selected;
  _anchor.visible = _anchorButton.selected;
}

- (void)clickLeftCanvas
{
  NSLog(@"click left canvas");
}

- (void)clickRightCanvas
{
  NSLog(@"click right canvas");
}

@end
