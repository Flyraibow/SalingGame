//
//  ItemInfoPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ItemInfoPanel.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"

@implementation ItemInfoPanel
{
    CCSprite *_itemPanel;
    ItemData *_itemData;
    ItemBrowsePanelType _type;
}

-(instancetype)initWithItemData:(ItemData *)itemData panelType:(ItemBrowsePanelType)type
{
    if (self = [super initWithNodeColor:[BGImage getShadowForBackground]]) {
        self.contentSize = [CCDirector sharedDirector].viewSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.anchorPoint = ccp(0.5, 0.5);
        
        _itemData = itemData;
        _type = type;
        
        _itemPanel = [CCSprite spriteWithImageNamed:@"itemDescFrame.jpg"];
        _itemPanel.positionType = CCPositionTypeNormalized;
        _itemPanel.position = ccp(0.5, 0.5);
        [self addChild:_itemPanel];
        
        DefaultButton *closeButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        closeButton.positionType = CCPositionTypeNormalized;
        closeButton.anchorPoint = ccp(1, 0);
        closeButton.position = ccp(0.98, 0.02);
        closeButton.scale = 0.5;
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        [_itemPanel addChild:closeButton];
    }
    return self;
}

-(void)clickCloseButton
{
    [_delegate closeItemInfoPanel];
    [self removeFromParent];
}

@end
