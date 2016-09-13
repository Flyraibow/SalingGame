//
//  ShipInfoSimpleIcon.m
//  FileTestProject
//
//  Created by Yujie Liu on 9/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipSimpleInfoIcon.h"
#import "GameShipData.h"

@implementation ShipSimpleInfoIcon
{
    __weak id _target;
    SEL _selector;
}

@synthesize inTeam = _inTeam;

-(instancetype)initWithShipData:(GameShipData *)shipData
{
    if (self = [super initWithImageNamed:@"ShipSimpeInfoFrame.png"]) {
        self.positionType = CCPositionTypePoints;
        CCSprite *shipIcon = [[CCSprite alloc] initWithImageNamed:shipData.shipIconImageName];
        shipIcon.positionType = CCPositionTypePoints;
        shipIcon.anchorPoint = ccp(0, 0);
        shipIcon.position = ccp(16, 8);
        [self addChild:shipIcon];
        self.scale = 0.6;
        self.anchorPoint = ccp(0.5, 1);
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setOpacity:(CGFloat)opacity
{
    [super setOpacity:opacity];
    for (CCNode *node in self.children) {
        [node setOpacity:opacity];
    }
}

-(void)setTarget:(id)target selector:(SEL)selector
{
    if ([target respondsToSelector:selector]) {
        _target = target;
        _selector = selector;
    } else {
        _target = nil;
        _selector = nil;
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
