//
//  MoneyPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "MoneyPanel.h"

@implementation MoneyPanel
{
    CCLabelTTF *_labelMoney;
}

-(instancetype)initWithText:(NSString *)labelText
{
    if (self = [super initWithImageNamed:@"frame_money.png"]) {
        CCLabelTTF *textLabel = [CCLabelTTF labelWithString:labelText fontName:nil fontSize:14];
        textLabel.positionType = CCPositionTypeNormalized;
        textLabel.anchorPoint = ccp(0, 0.5);
        textLabel.position = ccp(0.15, 0.75);
        [self addChild:textLabel];
        
        _labelMoney = [CCLabelTTF labelWithString:@"0" fontName:nil fontSize:14];
        _labelMoney.positionType = CCPositionTypeNormalized;
        _labelMoney.anchorPoint = ccp(1, 0.5);
        _labelMoney.position = ccp(0.85, 0.25);
        [self addChild:_labelMoney];
    }
    return self;
}

-(void)setMoney:(NSInteger)money
{
    _labelMoney.string = [@(money) stringValue];
}

@end
