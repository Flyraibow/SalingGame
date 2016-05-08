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
        
        CCLabelTTF *labName = [CCLabelTTF labelWithString:getItemName(itemData.itemId) fontName:nil fontSize:14];
        labName.positionType = CCPositionTypeNormalized;
        labName.anchorPoint = ccp(0, 0.5);
        labName.position = ccp(0.08, 0.9);
        [_itemPanel addChild:labName];
        
        DefaultButton *closeButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        closeButton.positionType = CCPositionTypeNormalized;
        closeButton.anchorPoint = ccp(1, 0);
        closeButton.position = ccp(0.98, 0.05);
        closeButton.scale = 0.5;
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        [_itemPanel addChild:closeButton];
        
        DefaultButton *selectButton = nil;
        if (type == ItemBrowsePanelTypeBuy) {
            selectButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_buy")];
        } else if (type == ItemBrowsePanelTypeSell) {
            selectButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_buy")];
        } else if (type == ItemBrowsePanelTypeBrowse) {
            if (itemData.type <= 3) {
                selectButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_equip")];
            } else if (itemData.value > 0) {
                selectButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_use")];
            }
        }
        
        if (selectButton != nil) {
            selectButton.positionType = CCPositionTypeNormalized;
            selectButton.anchorPoint = ccp(1, 0);
            selectButton.position = ccp(0.73, 0.05);
            selectButton.scale = 0.5;
            [selectButton setTarget:self selector:@selector(selectItem)];
            [_itemPanel addChild:selectButton];
        }
    }
    return self;
}

-(void)clickCloseButton
{
    [_delegate closeItemInfoPanel];
    [self removeFromParent];
}

-(void)selectItem
{
    [_delegate selectItemFromInfoPanel:_itemData];
}

@end
