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
  CCLabelTTF *_prefixLab;
  __weak id _target;
  SEL _selector;
}


- (instancetype)initWithPrefix:(NSString *)prefix
{
  self = [super initWithImageNamed:@"BlackFrame.jpg"];
  if (self) {
    if (prefix != nil && prefix.length > 0) {
      _prefixLab = [CCLabelTTF labelWithString:prefix fontName:nil fontSize:15];
      _prefixLab.positionType = CCPositionTypeNormalized;
      _prefixLab.position = ccp(0.07, 0.5);
      _prefixLab.anchorPoint = ccp(0, 0.5);
      [self addChild:_prefixLab];
    }

    _label = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:15];
    _label.positionType = CCPositionTypeNormalized;
    [self addChild:_label];
    self.center = NO;
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

- (void)setCenter:(BOOL)center
{
  _center = center;
  if (center) {
    _label.position = ccp(0.5, 0.5);
    _label.anchorPoint = ccp(0.5, 0.5);
  } else {
    _label.position = ccp(0.93, 0.5);
    _label.anchorPoint = ccp(1, 0.5);
  }
}

- (void)setVertical:(BOOL)vertical
{
  _vertical = vertical;
  if (vertical) {
    self.rotation = - 90;
  } else {
    self.rotation = 0;
  }
}

-(void)setTarget:(id)target selector:(SEL)selector
{
  if ([target respondsToSelector:selector]) {
    _target = target;
    _selector = selector;
    self.userInteractionEnabled = YES;
  } else {
    _target = nil;
    _selector = nil;
    self.userInteractionEnabled = NO;
  }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  // to make touchEnded respond
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  if (_target) {
    ((void (*)(id, SEL, id))[_target methodForSelector:_selector])(_target, _selector, self);
  }
}

@end
