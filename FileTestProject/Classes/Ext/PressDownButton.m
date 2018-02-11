//
//  PressDownButton.m
//  FileTestProject
//
//  Created by Yujie Liu on 1/3/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

#import "PressDownButton.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation PressDownButton
{
  BOOL _touchDown;
}

- (void)setTarget:(id)target selector:(SEL)selector
{
  __weak id weakTarget = target; // avoid retain cycle
  [self setBlock:^(id sender) {
    typedef void (*Func)(id, SEL, id);
    ((Func)objc_msgSend)(weakTarget, selector, sender);
  }];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  [super touchBegan:touch withEvent:event];
  if (self.enabled && self.block) {
    self.block(self);
    if (self.continuousEvent) {
      _touchDown = YES;
    }
  }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
  _touchDown = NO;
  [super touchEnded:touch withEvent:event];
}

- (void)update:(CCTime)delta
{
  if (_touchDown) {
    if (self.enabled && self.block) {
      self.block(self);
    }
  }
}

@end
