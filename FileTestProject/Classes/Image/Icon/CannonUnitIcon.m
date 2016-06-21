//
//  CannonUnitIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/20/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CannonUnitIcon.h"
#import "LocalString.h"

@implementation CannonUnitIcon
{
    CCSprite *_cannonIcon;
    CCLabelTTF *_labCannonName;
    CCLabelTTF *_labCannonDescription;
    int _cannonPower;
}

-(instancetype)initWithCannonPower:(int)cannonPower
{
    if (self = [super init]) {
        self.contentSize = CGSizeMake(kCannonUnitIconWidth, kCannonUnitIconHeight);
        _cannonPower = cannonPower;

        _cannonIcon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"cannon%d.png", cannonPower]];
        _cannonIcon.anchorPoint = ccp(0, 0.5);
        _cannonIcon.positionType = CCPositionTypeNormalized;
        _cannonIcon.position = ccp(0.1, 0.5);
        [self addChild:_cannonIcon];
        
        _labCannonName = [CCLabelTTF labelWithString:getCannonName(cannonPower) fontName:nil fontSize:10];
        _labCannonName.anchorPoint = ccp(0, 0.5);
        _labCannonName.positionType = CCPositionTypeNormalized;
        _labCannonName.position = ccp(0.4, 0.7);
        [self addChild:_labCannonName];
        
        _labCannonDescription = [CCLabelTTF labelWithString:getCannonDescription(cannonPower) fontName:nil fontSize:10];
        _labCannonDescription.anchorPoint = ccp(0, 0.5);
        _labCannonDescription.positionType = CCPositionTypeNormalized;
        _labCannonDescription.position = ccp(0.4, 0.3);
        [self addChild:_labCannonDescription];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        // TODO: to draw the render rect next time;
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate selectCannon:_cannonPower];
}

@end
