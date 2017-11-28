//
//  LabelFrame.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/26/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "LabelFrame.h"

@implementation LabelFrame
{
  CCLabelTTF *_label;
}


- (instancetype)initWithPrefix:(NSString *)prefix
{
  self = [super initWithImageNamed:@"BlackFrame.jpg"];
  if (self) {
    CCLabelTTF *prefixLab = [CCLabelTTF labelWithString:prefix fontName:nil fontSize:15];
    prefixLab.positionType = CCPositionTypeNormalized;
    prefixLab.position = ccp(0.07, 0.5);
    prefixLab.anchorPoint = ccp(0, 0.5);
    [self addChild:prefixLab];

    _label = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
    _label.positionType = CCPositionTypeNormalized;
    _label.position = ccp(0.93, 0.5);
    _label.anchorPoint = ccp(1, 0.5);
    [self addChild:_label];
  }
  return self;
}

- (instancetype)init
{
  return (self = [self initWithPrefix:@""]);
}

- (NSString *)string
{
  return _label.string;
}

- (void)setString:(NSString *)string
{
  _label.string = string;
}

@end
