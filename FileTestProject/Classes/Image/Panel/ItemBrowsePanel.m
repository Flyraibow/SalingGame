//
//  ItemBrowsePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ItemBrowsePanel.h"
#import "BGImage.h"
#import "LabelButton.h"
#import "LocalString.h"
#import "DefaultButton.h"
#import "GameDataManager.h"
#import "DataManager.h"
#import "ItemData.h"
#import "ItemIcon.h"

@interface ItemBrowsePanel() <ItemIconSelectionDelegate>

@end

@implementation ItemBrowsePanel
{
    CCSprite *_panel;
    NSMutableArray *_buttonList;
    LabelButton *_selectedButton;
    NSMutableDictionary *_itemDictionary;
    ItemBrowsePanelType _panelType;
    NSMutableArray *_showItemSpriteList;
}

-(instancetype)initWithItems:(NSArray *)items panelType:(ItemBrowsePanelType)type
{
    if (self = [super initWithNodeColor:[BGImage getShadowForBackground]]) {
        self.contentSize = [CCDirector sharedDirector].viewSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.anchorPoint = ccp(0.5, 0.5);
        
        _panelType = type;
        _panel = [CCSprite spriteWithImageNamed:@"ItemBrowsePanel.jpg"];
        _panel.positionType = CCPositionTypeNormalized;
        _panel.position = ccp(0.5, 0.1);
        _panel.anchorPoint = ccp(0.5, 0);
        _panel.scale = (self.contentSize.height - 20) / _panel.contentSize.height * 0.8;
        [self addChild:_panel];
        
        DefaultButton *closeButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        closeButton.scale = 0.5;
        closeButton.anchorPoint = ccp(1,0);
        closeButton.positionType = CCPositionTypePoints;
        closeButton.position = ccp(_panel.contentSize.width - 10, 10);
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        [_panel addChild:closeButton];
        
        _buttonList = [NSMutableArray new];
        CGFloat startX = 0.0;
        for (int i = 0; i < 6; ++i) {
            LabelButton *labButton = [[LabelButton alloc] initWithTitle:getLocalStringByInt(@"item_category_", i + 1)];
            labButton.name = [@(i + 1) stringValue];
            labButton.anchorPoint = ccp(0, 0);
            labButton.positionType = CCPositionTypePoints;
            labButton.position = ccp(startX, _panel.contentSize.height);
            startX += labButton.contentSize.width * _panel.scale;
            [labButton setTarget:self selector:@selector(clickLabelButton:)];
            
            [_panel addChild:labButton];
            [_buttonList addObject:labButton];
        }
        _itemDictionary = [NSMutableDictionary new];
        ItemDic *itemDic = [[DataManager sharedDataManager] getItemDic];
        for (int i = 0; i < items.count; ++i) {
            NSString *itemId = items[i];
            ItemData *item = [itemDic getItemById:itemId];
            NSString *categoryNo = [@(item.type) stringValue];
            NSMutableArray *array = [_itemDictionary objectForKey:categoryNo];
            if (array == nil) {
                array = [NSMutableArray new];
                [_itemDictionary setObject:array forKey:categoryNo];
            }
            [array addObject:item];
        }
        _showItemSpriteList = [NSMutableArray new];
        [self setItemCategoryId:@"1"];
    }
    return self;
}

-(void)setItemCategoryId:(NSString *)categoryId
{
    _selectedButton.selected = NO;
    _selectedButton = _buttonList[[categoryId intValue] - 1];
    _selectedButton.selected = YES;
    
    NSMutableArray *itemList = [_itemDictionary objectForKey:categoryId];
    int i = 0;
    for (; i < itemList.count; ++i) {
        ItemData *item = itemList[i];
        ItemIcon *itemIcon;
        if (i < _showItemSpriteList.count) {
            itemIcon = _showItemSpriteList[i];
            itemIcon.visible = YES;
        } else {
            itemIcon = [[ItemIcon alloc] init];
            itemIcon.delegate = self;
            itemIcon.positionType = CCPositionTypeNormalized;
            int x = i % 8;
            int y = i / 8;
            itemIcon.position = ccp( 1.0 / 16 * (1 + x * 2), 0.9 - y * 0.1);
            [_panel addChild: itemIcon];
            [_showItemSpriteList addObject:itemIcon];
        }
        itemIcon.itemData = item;
    }
    for (; i < _showItemSpriteList.count; ++i) {
        ItemIcon *itemIcon = _showItemSpriteList[i];
        itemIcon.visible = NO;
    }
}

-(void)clickLabelButton:(LabelButton *)button
{
    if (_selectedButton != button) {
        [self setItemCategoryId:button.name];
    } else {
        button.selected = YES;
    }
}

-(void)clickCloseButton
{
    [self removeFromParent];
}

-(void)selectItem:(ItemData *)itemData
{
    NSLog(@"select Item: %@", itemData.iconId);
}

@end
