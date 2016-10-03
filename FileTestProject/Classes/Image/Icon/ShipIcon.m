//
//  ShipIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipIcon.h"

@implementation ShipIcon
{
    CCSprite *_icon;
}

-(instancetype)initWithShipIconNo:(NSString *)shipIconNo
{
    if (self = [super initWithImageNamed:@"shipIconFrame.png"]) {
        
        if (shipIconNo != nil) {
            _icon = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"ship%@.png",shipIconNo]];
            _icon.positionType = CCPositionTypePoints;
            _icon.anchorPoint = ccp(0, 1);
            _icon.position = ccp(5,self.contentSize.height - 5);
            [self addChild:_icon];
        }
        
    }
    return self;
}

-(void)setOpacity:(CGFloat)opacity
{
    super.opacity = opacity;
    _icon.opacity = opacity;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate selectShipIconIndex:self];
}

@end
