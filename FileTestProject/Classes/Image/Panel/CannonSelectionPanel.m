//
//  CannonSelectionPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/20/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CannonSelectionPanel.h"
#import "CannonUnitIcon.h"
#import "DefaultButton.h"
#import "LocalString.h"

@interface CannonSelectionPanel() <CannonUnitIconDelegate>

@end

@implementation CannonSelectionPanel

-(instancetype)initWithCannonList:(NSArray *)cannonList currCannonId:(int)cannonId
{
    NSUInteger count = cannonList.count;
    CGFloat width = kCannonUnitIconWidth;
    CGFloat height = kCannonUnitIconHeight * count + 30;
    if (self = [super initWithSize:CGSizeMake(width, height)]) {
        for (int i = 0; i < count; ++i) {
            CannonUnitIcon *icon = [[CannonUnitIcon alloc] initWithCannonPower:[cannonList[i] intValue]];
            icon.anchorPoint = ccp(0, 1);
            icon.positionType = CCPositionTypePoints;
            icon.position = ccp(0, height - i * kCannonUnitIconHeight - 5);
            icon.delegate = self;
            [self.frame addChild:icon];
        }
    }
    DefaultButton *btnClose = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
    btnClose.positionType = CCPositionTypeNormalized;
    btnClose.anchorPoint = ccp(0.5, 0);
    btnClose.position = ccp(0.5, 0);
    btnClose.scale = 0.5;
    [self.frame addChild:btnClose];
    [btnClose setTarget:self selector:@selector(clickCloseButton)];
    return self;
}

-(void)clickCloseButton
{
    [self removeFromParent];
}

-(void)selectCannon:(int)cannonPower
{
    [self removeFromParent];
    [_delegate selectCannon:cannonPower];
}


@end
