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
#import "GameValueManager.h"

const static int kShowItemNumberEachLine = 7;
const static int kShowLinesNumber = 4;

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
  ItemInfoPanel *_itemInfoPanel;
  NSArray *_itemList;
  NSUInteger _selecteItemIndex;
  CCButton *_upButton;
  CCButton *_downButton;
  NSString *_categoryId;
  int _startLine;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  if (self = [super init]) {
    _panelType = [dataList[0] integerValue];
    NSArray *items = getItemsByPanelType(_panelType, self.cityId);
    NSString *defaultCategory = nil;
    GameItemData *itemData = [GameValueManager sharedValueManager].reservedItemData;
    if (_panelType == ItemBrowsePanelTypeEquip) {
      NSInteger category = [GameValueManager sharedValueManager].reservedItemCategory;
      defaultCategory = [@(category) stringValue];
    } else if (itemData) {
      defaultCategory = [@(itemData.itemData.category) stringValue];
    } else if (items.count > 0) {
      itemData = items[0];
      defaultCategory = [@(itemData.itemData.category) stringValue];
    }
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
    [self setItems:items defaultCategory:defaultCategory];
  }
  return self;
}


-(void)setItems:(NSArray *)items defaultCategory:(NSString *)defautCategoryNo
{
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
  self.completionBlockWithEventId(self.cancelEvent);
}

-(void)selectItem:(GameItemData *)gameItemData
{
  [self removeFromParent];
  [GameValueManager sharedValueManager].reservedItemData = gameItemData;
  self.completionBlockWithEventId(self.successEvent);
}

/*
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
 [dialogPanel setDefaultDialog:@"dialog_buy_item" arguments:@[getItemName(gameItemData.itemId), @(gameItemData.itemData.price)]];
 [dialogPanel addSelections:@[getLocalString(@"lab_buy"), getLocalString(@"btn_cancel")] callback:^(int index) {
 if (index == 0) {
 [self removeChild:weakItemInfoPanel];
 _panel.visible = YES;
 MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
 if (gameItemData.itemData.price <= myguild.money) {
 //                    [myguild buyItem:gameItemData withMoney:gameItemData.itemData.price];
 //刷新界面
 NSMutableArray *items = [_itemList mutableCopy];
 [items removeObject:gameItemData];
 [self setItems:items];
 }
 }
 }];
 } else if (_panelType == ItemBrowsePanelTypeSell) {
 __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
 __weak ItemInfoPanel *weakItemInfoPanel = _itemInfoPanel;
 int price = gameItemData.itemData.price * 0.5;
 [dialogPanel setDefaultDialog:@"dialog_sell_item" arguments:@[getItemName(gameItemData.itemId), @(price)]];
 [dialogPanel addSelections:@[getLocalString(@"lab_sell"), getLocalString(@"btn_cancel")] callback:^(int index) {
 if (index == 0) {
 [self removeChild:weakItemInfoPanel];
 _panel.visible = YES;
 MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
 //                [myguild sellItem:gameItemData withMoney:price toCityId:self.cityId];
 NSMutableArray *items = [_itemList mutableCopy];
 [items removeObject:gameItemData];
 [self setItems:items];
 }
 }];
 } else if (_panelType == ItemBrowsePanelTypeBrowse) {
 if (gameItemData.itemData.category <= ItemCategoryOtherEquip) {
 // equip 弹出对话之后弹出选人界面
 __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
 __weak ItemInfoPanel *weakItemInfoPanel = _itemInfoPanel;
 if (gameItemData.roleId) {
 [gameItemData unequip];
 [dialogPanel setDefaultDialog:@"dialog_unequip_an_equipment" arguments:nil];
 [dialogPanel addConfirmHandler:^{
 [self removeChild:weakItemInfoPanel];
 _panel.visible = YES;
 }];
 } else {
 [dialogPanel setDefaultDialog:@"dialog_equip_an_equipment" arguments:nil];
 [dialogPanel addConfirmHandler:^{
 NSArray *npcList = [GameDataManager sharedGameData].myGuild.myTeam.npcList;
 RolePanel *rolePanel = [[RolePanel alloc] initWithNpcList:npcList type:RolePanelTypeEquip];
 RolePanel *blockRolePanel = rolePanel;
 rolePanel.selectHandler = ^(NSString *roleId) {
 GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:roleId];
 assert(npcData);
 NPCEquipError err;
 if ((err = [npcData canEquip:gameItemData]) == NPCEquipErrorNone) {
 // 装备上
 [npcData equip:gameItemData];
 [dialogPanel setDefaultDialog:@"dialog_equip_an_equipment_success" arguments:nil];
 [dialogPanel addConfirmHandler:^{
 // 关闭role Panel
 [self.scene removeChild:blockRolePanel];
 [self removeChild:weakItemInfoPanel];
 _panel.visible = YES;
 }];
 } else {
 // 弹出文字无法装备
 // TODO： 增加原因
 if (npcData.isCaptain) {
 
 [dialogPanel setDefaultDialog:@"dialog_i_cannot_equip" arguments:@[gameItemData.itemName]];
 } else {
 [dialogPanel setDefaultDialog:@"dialog_cannot_equip" arguments:@[npcData.firstName, gameItemData.itemName]];
 }
 }
 };
 [self.scene addChild:rolePanel];
 }];
 }
 } else if (gameItemData.itemData.type == ItemTypeShipHeader) {
 // equip 弹出对话之后弹出选船界面
 __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
 __weak ItemInfoPanel *weakItemInfoPanel = _itemInfoPanel;
 if (gameItemData.shipId) {
 ShipUnequipError err = ShipUnequipErrorNone;
 void(^uneuquipSuccess)() = ^(){
 [dialogPanel setDefaultDialog:@"dialog_unequip_a_shipheader" arguments:nil];
 [dialogPanel addConfirmHandler:^{
 [self removeChild:weakItemInfoPanel];
 _panel.visible = YES;
 }];
 };
 if ((err = [gameItemData unequipShipheader]) == ShipUnequipErrorNone) {
 uneuquipSuccess();
 } else if (err == ShipUnequipErrorDemon) {
 //弹出提示，拆除会损坏船只是否强行拆除
 [dialogPanel setDefaultDialog:@"dialog_cannot_unequip_a_shipheader_demon" arguments:nil];
 [dialogPanel addYesNoWithCallback:^(int index) {
 if (index == 0) {
 ShipUnequipError error;
 if ((error = [gameItemData unequipShipheaderWithForce:YES]) == ShipUnequipErrorNone) {
 uneuquipSuccess();
 } else if (error == ShipUnequipErrorDemonFirst) {
 [dialogPanel setDefaultDialog:@"dialog_cannot_unequip_a_shipheader_demon_first" arguments:nil];
 }
 }
 }];
 }
 } else {
 [dialogPanel setDefaultDialog:@"dialog_equip_a_shipheader" arguments:nil];
 [dialogPanel addConfirmHandler:^{
 //                    GameTeamData * team = [GameDataManager sharedGameData].myGuild.myTeam;
 //                    NSMutableArray *shipList = [team shipDataList];
 //                    [shipList addObjectsFromArray:[team getCarryShipListInCity:team.currentCityId]];
 //                    ShipExchangeScene *shipExchangeScene = [[ShipExchangeScene alloc] initWithShipList:shipList sceneType:ShipSceneTypeEquip];
 //                    shipExchangeScene.selectHandler = ^ (GameShipData *gameShipData) {
 //                        assert(gameShipData);
 //                        [[CCDirector sharedDirector] popScene];
 //                        // TODO: 如果是恶魔像 额外提示下
 //                        [gameShipData equip:gameItemData];
 //                        [self removeChild:weakItemInfoPanel];
 //                        [dialogPanel setDefaultDialog:@"dialog_equip_an_equipment_success" arguments:nil];
 //                        [dialogPanel addConfirmHandler:^{
 //                            _panel.visible = YES;
 //                        }];
 //                    };
 //                    [[CCDirector sharedDirector] pushScene:shipExchangeScene];
 }];
 }
 } else if (gameItemData.itemData.value > 0) {
 // use
 }
 } else if (_panelType == ItemBrowsePanelTypeEquip) {
 assert(self.equipedRoleId);
 GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:self.equipedRoleId];
 if (gameItemData.roleId) {
 if ([self.equipedRoleId isEqualToString:gameItemData.roleId]) {
 [npcData unequip:gameItemData];
 } else {
 [gameItemData unequip];
 [npcData equip:gameItemData];
 }
 } else {
 [npcData equip:gameItemData];
 }
 [_itemInfoPanel removeFromParent];
 [self.delegate updatePanel];
 [self removeFromParent];
 // update
 } else if (_panelType == ItemBrowsePanelTypeShipHeader) {
 assert(self.equipedShipId);
 
 GameShipData *shipData = [[GameDataManager sharedGameData].shipDic objectForKey:self.equipedShipId];
 if (gameItemData.shipId) {
 if ([self.equipedShipId isEqualToString:gameItemData.shipId]) {
 [shipData unequip:gameItemData];
 } else {
 ShipUnequipError err = [gameItemData unequipShipheader];
 if (err == ShipUnequipErrorNone) {
 [shipData equip:gameItemData];
 } else {
 __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
 [dialogPanel setDefaultDialog:@"dialog_cannot_unequip_a_shipheader" arguments:nil];
 return;
 }
 }
 } else {
 // TODO: 如果是恶魔像 额外提示下
 [shipData equip:gameItemData];
 }
 [_itemInfoPanel removeFromParent];
 [self.delegate updatePanel];
 [self removeFromParent];
 }
 }
 */
@end

