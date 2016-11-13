//
//  PopUpFrame.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/20/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "PopUpFrame.h"
#import "BGImage.h"

@implementation PopUpFrame
{
}

@synthesize frame = _frame;

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithNode:[BGImage getTransparentBackground]]) {
        _frame = [CCSprite9Slice spriteWithImageNamed:@"default_frame.png"];
        _frame.anchorPoint = ccp(0.5, 0.5);
        _frame.positionType = CCPositionTypeNormalized;
        _frame.position = ccp(0.5, 0.5);
        [self addChild:_frame];
        [self setFrameSize:size];
    }
    return self;
}

-(void)setFrameSize:(CGSize)size
{
    _frame.contentSize = size;
}

@end
