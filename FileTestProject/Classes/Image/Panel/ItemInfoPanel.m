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
#import "CCSprite+Ext.h"

@implementation ItemInfoPanel
{
    CCSprite *_itemPanel;
    ItemData *_itemData;
    ItemBrowsePanelType _type;
    DefaultButton *_selectButton;
    CCButton *_leftBtn;
    CCButton *_rightBtn;
    CCLabelTTF *_labName;
    CCLabelTTF *_labType;
    CCLabelTTF *_labDescription;
    CCSprite *_itemIcon;
}

-(instancetype)initWithPanelType:(ItemBrowsePanelType)type
{
    if (self = [super initWithNodeColor:[BGImage getShadowForBackground]]) {
        self.contentSize = [CCDirector sharedDirector].viewSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.anchorPoint = ccp(0.5, 0.5);
        
        _type = type;
        
        _itemPanel = [CCSprite spriteWithImageNamed:@"itemDescFrame.jpg"];
        _itemPanel.positionType = CCPositionTypeNormalized;
        _itemPanel.position = ccp(0.5, 0.5);
        [self addChild:_itemPanel];
        
        _labName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labName.positionType = CCPositionTypeNormalized;
        _labName.anchorPoint = ccp(0, 0.5);
        _labName.position = ccp(0.08, 0.9);
        [_itemPanel addChild:_labName];
        
        _labType = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labType.positionType = CCPositionTypeNormalized;
        _labType.anchorPoint = ccp(0, 0.5);
        _labType.position = ccp(0.08, 0.81);
        [_itemPanel addChild:_labType];
        
        _labDescription = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14 dimensions:CGSizeMake(160, 132)];
        _labDescription.color = [CCColor blackColor];
        _labDescription.positionType = CCPositionTypeNormalized;
        _labDescription.anchorPoint = ccp(0, 1);
        _labDescription.position = ccp(0.07, 0.7);
        
        [_itemPanel addChild:_labDescription];
        
        DefaultButton *closeButton = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        closeButton.positionType = CCPositionTypeNormalized;
        closeButton.anchorPoint = ccp(1, 0);
        closeButton.position = ccp(0.98, 0.05);
        closeButton.scale = 0.5;
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        [_itemPanel addChild:closeButton];
        
        
        _rightBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"rightArrowButton.png"]];
        _rightBtn.positionType = CCPositionTypeNormalized;
        _rightBtn.anchorPoint = ccp(1, 0.5);
        _rightBtn.position = ccp(0.95, 0.5);
        [_rightBtn setTarget:self selector:@selector(clickRightButton)];
        [self addChild:_rightBtn];
        
        
        _leftBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leftArrowButton.png"]];
        _leftBtn.positionType = CCPositionTypeNormalized;
        _leftBtn.anchorPoint = ccp(0, 0.5);
        _leftBtn.position = ccp(0.05, 0.5);
        [_leftBtn setTarget:self selector:@selector(clickLeftButton)];
        [self addChild:_leftBtn];
        
        _selectButton = [DefaultButton buttonWithTitle:@""];
        _selectButton.positionType = CCPositionTypeNormalized;
        _selectButton.anchorPoint = ccp(1, 0);
        _selectButton.position = ccp(0.73, 0.05);
        _selectButton.scale = 0.5;
        [_selectButton setTarget:self selector:@selector(selectItem)];
        [_itemPanel addChild:_selectButton];
    }
    return self;
}

-(void)setItemData:(ItemData *)itemData
{
    if (_itemData != itemData) {
        
        _itemData = itemData;
        _labName.string = getItemName(itemData.itemId);
        _labDescription.string = getItemDescription(itemData.itemId);
        _labType.string = getItemType(itemData.type);
        
        if (_itemIcon != nil) {
            [_itemIcon removeFromParent];
        }
        _itemIcon = [[CCSprite alloc] initWithImageNamed:[NSString stringWithFormat:@"item%@.png", itemData.iconId]];
        [_itemIcon setRect:CGRectMake(191, 152, 56, 56)];
        [_itemPanel addChild:_itemIcon];
        
        if (_type == ItemBrowsePanelTypeBuy) {
            _selectButton.title = getLocalString(@"lab_buy");
            _selectButton.visible = YES;
        } else if (_type == ItemBrowsePanelTypeSell) {
            _selectButton.title = getLocalString(@"lab_sell");
            _selectButton.visible = YES;
        } else if (_type == ItemBrowsePanelTypeBrowse) {
            if (itemData.category <= 3) {
                _selectButton.title = getLocalString(@"lab_equip");
                _selectButton.visible = YES;
            } else if (itemData.value > 0) {
                _selectButton.title = getLocalString(@"lab_use");
                _selectButton.visible = YES;
            } else {
                _selectButton.visible = NO;
            }
        }
    }
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

-(void)clickRightButton
{
    [_delegate selectNextItem];
}

-(void)clickLeftButton
{
    [_delegate selectPrevItem];
}

@end
