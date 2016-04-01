//
//  GoodsPricePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/11/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GoodsPricePanel.h"

@implementation GoodsPricePanel
{
    CCSprite *_bgSprite;
    CGSize _contentSize;
}

-(instancetype)init
{
    if (self = [super init]) {
        _contentSize = [CCDirector sharedDirector].viewSize;
        _bgSprite = [CCSprite spriteWithImageNamed:@"bg_trade_info.png"];
        _bgSprite.anchorPoint = ccp(0,1);
        _bgSprite.scale = _contentSize.height / _bgSprite.contentSize.height;
        [self addChild:_bgSprite];
        
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0 ,1);
    }
    return self;
}

-(void)setCityNo:(NSString *)cityNo
{
    
}

@end
