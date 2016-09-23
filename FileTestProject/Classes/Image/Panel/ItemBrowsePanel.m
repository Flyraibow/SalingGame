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
#import "GamePanelManager.h"
#import "GameItemData.h"
#import "RolePanel.h"
#import "GameNPCData.h"

const static int kShowItemNumberEachLine = 7;
const static int kShowLinesNumber = 4;

@interface ItemBrowsePanel() <ItemIconSelectionDelegate, ItemInfoPanelDelegate>

@end

@implementation ItemBrowsePanel
{
    CCSprite *_panel;
    NSMutableArray *_buttonList;
    LabelButton *_selectedButton;
    NSMutableDictionary *_itemDictionary;
    ItemBrowsePanelType _panelType;
    NSMutableArray *_showItemSpriteList;
    ItemInfoPanel *_itemInfoPanel;
    NSArray *_itemList;
    NSUInteger _selecteItemIndex;
    CCButton *_upButton;
    CCButton *_downButton;
    NSString *_categoryId;
    int _startLine;
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
        
        _upButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"upArrowButton.png"]];
        _upButton.positionType = CCPositionTypeNormalized;
        _upButton.position = ccp(0.95, 0.95);
        [_upButton setTarget:self selector:@selector(clickUpButton)];
        [_panel addChild:_upButton];
        
        _downButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"downArrowButton.png"]];
        _downButton.positionType = CCPositionTypeNormalized;
        _downButton.position = ccp(0.95, 0.15);
        [_downButton setTarget:self selector:@selector(clickDownButton)];
        [_panel addChild:_downButton];
        
        
        _showItemSpriteList = [NSMutableArray new];
        [self setItems:items];
    }
    return self;
}

-(void)setItems:(NSArray *)items
{
    NSString *defautCategoryNo = nil;
    BOOL categorySet = NO;
    _itemDictionary = [NSMutableDictionary new];
    for (int i = 0; i < items.count; ++i) {
        GameItemData *item = items[i];
        NSString *categoryNo = [@(item.itemData.category) stringValue];
        if (!categorySet) {
            if ([categoryNo isEqualToString:_categoryId]) {
                defautCategoryNo = categoryNo;
                categorySet = YES;
            } else if (!defautCategoryNo) {
                defautCategoryNo = categoryNo;
            }
        }
        NSMutableArray *array = [_itemDictionary objectForKey:categoryNo];
        if (array == nil) {
            array = [NSMutableArray new];
            [_itemDictionary setObject:array forKey:categoryNo];
        }
        [array addObject:item];
    }
    _itemList = items;
    if (!defautCategoryNo) {
        defautCategoryNo = @"1";
    }
    [self setItemCategoryId:defautCategoryNo startLine:0];
}

-(void)setItemCategoryId:(NSString *)categoryId startLine:(int)startLine
{
    _categoryId = categoryId;
    _startLine = startLine;
    _selectedButton.selected = NO;
    _selectedButton = _buttonList[[categoryId intValue] - 1];
    _selectedButton.selected = YES;
    
    NSMutableArray *itemList = [_itemDictionary objectForKey:categoryId];
    int i = startLine * kShowItemNumberEachLine;
    int j = 0;
    _upButton.enabled = startLine > 0;
    _downButton.enabled = NO;
    for (; i < itemList.count; ++i, ++j) {
        GameItemData *item = itemList[i];
        ItemIcon *itemIcon;
        if (j < _showItemSpriteList.count) {
            itemIcon = _showItemSpriteList[j];
            itemIcon.visible = YES;
        } else {
            int x = j % kShowItemNumberEachLine;
            int y = j / kShowItemNumberEachLine;
            if (y >= kShowLinesNumber) {
                // 超出数量了
                _downButton.enabled = YES;
                break;
            }
            itemIcon = [[ItemIcon alloc] init];
            itemIcon.delegate = self;
            itemIcon.positionType = CCPositionTypeNormalized;
            itemIcon.position = ccp( 0.93 / kShowItemNumberEachLine * (1 + x * 2) / 2, 0.9 - y * 0.2);
            [_panel addChild: itemIcon];
            [_showItemSpriteList addObject:itemIcon];
        }
        itemIcon.itemData = item;
    }
    for (; j < _showItemSpriteList.count; ++j) {
        ItemIcon *itemIcon = _showItemSpriteList[j];
        itemIcon.visible = NO;
    }
}

-(void)clickUpButton
{
    [self setItemCategoryId:_categoryId startLine:_startLine - 1];
}

-(void)clickDownButton
{
    [self setItemCategoryId:_categoryId startLine:_startLine + 1];
}

-(void)clickLabelButton:(LabelButton *)button
{
    if (_selectedButton != button) {
        [self setItemCategoryId:button.name startLine:0];
    } else {
        button.selected = YES;
    }
}

-(void)clickCloseButton
{
    [self removeFromParent];
}

-(void)selectItem:(GameItemData *)gameItemData
{
    _selecteItemIndex = [_itemList indexOfObject:gameItemData];
    if (_itemInfoPanel == nil) {
        _itemInfoPanel = [[ItemInfoPanel alloc] initWithPanelType:_panelType];
        _itemInfoPanel.delegate = self;
        [self addChild:_itemInfoPanel];
    } else if (_itemInfoPanel.parent == nil) {
        [self addChild:_itemInfoPanel];
    }
    _itemInfoPanel.itemData = gameItemData;
    _panel.visible = NO;
}

-(void)closeItemInfoPanel
{
    _panel.visible = YES;
}

-(void)selectPrevItem
{
    GameItemData *gameItemData = [_itemList objectAtIndex:_selecteItemIndex];
    NSArray *gameItemList = [_itemDictionary objectForKey:[@(gameItemData.itemData.category) stringValue]];
    NSUInteger index = [gameItemList indexOfObject:gameItemData];
    if (index > 0) {
        gameItemData = gameItemList[--index];
    } else {
        int category = gameItemData.itemData.category;
        int originCategory = category;
        do {
            --category;
            if (category <= 0) {
                category = 6;
            }
            gameItemList = [_itemDictionary objectForKey:[@(category) stringValue]];
        } while (gameItemList.count == 0 && originCategory != category);
        gameItemData = gameItemList[gameItemList.count - 1];
    }
    [self selectItem:gameItemData];
}

-(void)selectNextItem
{
    GameItemData *gameItemData = [_itemList objectAtIndex:_selecteItemIndex];
    NSArray *gameItemList = [_itemDictionary objectForKey:[@(gameItemData.itemData.category) stringValue]];
    NSUInteger index = [gameItemList indexOfObject:gameItemData];
    if (index + 1 < gameItemList.count) {
        gameItemData = gameItemList[++index];
    } else {
        int category = gameItemData.itemData.category;
        int originCategory = category;
        do {
            ++category;
            if (category > 6) {
                category = 1;
            }
            gameItemList = [_itemDictionary objectForKey:[@(category) stringValue]];
        } while (gameItemList.count == 0 && originCategory != category);
        gameItemData = gameItemList[0];
    }
    [self selectItem:gameItemData];
}

-(void)selectItemFromInfoPanel:(GameItemData *)gameItemData
{
    if (_panelType == ItemBrowsePanelTypeBuy) {
        // 调用对话，询问是否购买
        __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
        __weak ItemInfoPanel *weakItemInfoPanel = _itemInfoPanel;
        CityData *cityData = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo];
        [dialogPanel setDefaultDialog:@"dialog_buy_item" arguments:@[getItemName(gameItemData.itemId), @(gameItemData.itemData.price)] cityStyle:cityData.cityStyle];
        [dialogPanel addSelections:@[getLocalString(@"lab_buy"), getLocalString(@"btn_cancel")] callback:^(int index) {
            if (index == 0) {
                [self removeChild:weakItemInfoPanel];
                _panel.visible = YES;
                MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
                if (gameItemData.itemData.price <= myguild.money) {
                    [myguild buyItem:gameItemData withMoney:gameItemData.itemData.price];
                    //刷新界面
                    NSMutableArray *items = [_itemList mutableCopy];
                    [items removeObject:gameItemData];
                    [self setItems:items];
                }
            }
         }];
    } else if (_panelType == ItemBrowsePanelTypeSell) {
        __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
        __weak ItemInfoPanel *weakItemInfoPanel = 0;
        CityData *cityData = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo];
        int price = gameItemData.itemData.price * 0.5;
        [dialogPanel setDefaultDialog:@"dialog_sell_item" arguments:@[getItemName(gameItemData.itemId), @(price)] cityStyle:cityData.cityStyle];
        [dialogPanel addSelections:@[getLocalString(@"lab_sell"), getLocalString(@"btn_cancel")] callback:^(int index) {
            if (index == 0) {
                [self removeChild:weakItemInfoPanel];
                _panel.visible = YES;
                MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
                [myguild sellItem:gameItemData withMoney:price toCityId:_cityNo];
                NSMutableArray *items = [_itemList mutableCopy];
                [items removeObject:gameItemData];
                [self setItems:items];
            }
        }];
    } else if (_panelType == ItemBrowsePanelTypeBrowse) {
        if (gameItemData.itemData.category <= 3) {
            // equip 弹出对话之后弹出选人界面
            __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
            
            [dialogPanel setDefaultDialog:@"dialog_equip_an_equipment" arguments:nil];
            [dialogPanel addConfirmHandler:^{
                NSArray *npcList = [GameDataManager sharedGameData].myGuild.myTeam.npcList;
                RolePanel *rolePanel = [[RolePanel alloc] initWithNpcList:npcList type:RolePanelTypeEquip];
                __block RolePanel *blockRolePanel = rolePanel;
                rolePanel.selectHandler = ^(NSString *roleId) {
                    GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:roleId];
                    assert(npcData);
                    if ([npcData canEquip:gameItemData]) {
                        // 装备上
                        [npcData equip:gameItemData];
                        // 关闭role Panel
                        [self.scene removeChild:blockRolePanel];
                    } else {
                        // 弹出文字无法装备
                        // TODO： 修改文字成 某某无法装备某某
                        [dialogPanel setDefaultDialog:@"dialog_cannot_equip" arguments:@[npcData.firstName, gameItemData.itemName]];
                    }
                };
                [self.scene addChild:rolePanel];
            }];
        } else if (gameItemData.itemData.value > 0) {
            // use
        }
    }
}

@end
