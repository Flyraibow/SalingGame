//
//  BGImage.m
//  FileTestProject
//
//  Created by LIU YUJIE on 1/29/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BGImage.h"

static CGSize _contentSize;
static DialogPanel *_dialogPanel;

@interface CCNodeColor (Ext)

@end

@implementation CCNodeColor (Ext)

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // Swallow the mouse touches
}

@end

@implementation BGImage

+(CCSprite *)getBgImageByName:(NSString *)imageName
{
    CCSprite *sprite = [CCSprite spriteWithImageNamed:imageName];
    sprite.positionType = CCPositionTypeNormalized;
    sprite.position = ccp(0.5,0.5);
    sprite.scaleX = _contentSize.width / sprite.contentSize.width;
    sprite.scaleY = _contentSize.height / sprite.contentSize.height;
    return sprite;
}

+(CCNodeColor *)getShadowForBackground
{
    CCNodeColor *node = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.5] width:_contentSize.width height:_contentSize.height];
    node.contentSize = _contentSize;
    node.positionType = CCPositionTypeNormalized;
    node.anchorPoint = ccp(0.5,0.5);
    node.position = ccp(0.5, 0.5);
    node.userInteractionEnabled = YES;
    return node;
}

+(CCNode *)getTransparentBackground
{
    CCNodeColor *node = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0] width:_contentSize.width height:_contentSize.height];
    node.contentSize = _contentSize;
    node.positionType = CCPositionTypeNormalized;
    node.anchorPoint = ccp(0.5,0.5);
    node.position = ccp(0.5, 0.5);
    node.userInteractionEnabled = YES;
    return node;
}

+(void)initWithGroundSize:(CGSize)contentSize
{
    _contentSize = contentSize;
}

@end
