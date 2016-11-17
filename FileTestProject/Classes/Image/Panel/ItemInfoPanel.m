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
#import "GameValueManager.h"
#import "GameDataManager.h"

NSArray *getItemsByPanelType(ItemBrowsePanelType type, NSString *cityId)
{
    NSArray *items = nil;
    switch (type) {
        case ItemBrowsePanelTypeBuy:
            items = [[GameDataManager sharedGameData] itemListByCity:cityId];
            break;
        case ItemBrowsePanelTypeSell:
            items = [[GameDataManager sharedGameData] itemListByGuild:[GameDataManager sharedGameData].myGuild.guildId];
            break;
        case ItemBrowsePanelTypeBrowse:
            items = [[GameDataManager sharedGameData] itemListByGuild:[GameDataManager sharedGameData].myGuild.guildId];
            break;
        case ItemBrowsePanelTypeEquip:
        case ItemBrowsePanelTypeSingle:
        case ItemBrowsePanelTypeShipHeader:
            break;
    }
    if (items) {
        items = [items sortedArrayUsingComparator:^NSComparisonResult(GameItemData *item1, GameItemData *item2) {
            if (item1.itemData.category != item2.itemData.category) {
                return item1.itemData.category - item2.itemData.category;
            }
            return [(item1.itemData.itemId) integerValue] - [(item2.itemData.itemId) integerValue];
        }];
    }
    return items;
}

@implementation ItemInfoPanel
{
    CCSprite *_itemPanel;
    GameItemData *_itemData;
    ItemBrowsePanelType _type;
    DefaultButton *_selectButton;
    CCButton *_leftBtn;
    CCButton *_rightBtn;
    CCLabelTTF *_labName;
    CCLabelTTF *_labType;
    CCLabelTTF *_labDescription;
    CCSprite *_itemIcon;
    CCLabelTTF *_labValue;
    CCLabelTTF *_labEquipType;
    NSArray *_itemList;
    NSInteger _index;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
    if (self = [super initWithNode:[BGImage getShadowForBackground]]) {
        self.contentSize = [CCDirector sharedDirector].viewSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.anchorPoint = ccp(0.5, 0.5);
        
        _type = [dataList[0] integerValue];
        _itemList = getItemsByPanelType(_type, self.cityId);
        NSString *itemId = [[GameValueManager sharedValueManager] getStringByTerm:dataList[1]];
        
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
        
        if (_type != ItemBrowsePanelTypeSingle) {
            _rightBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"rightArrowButton.png"]];
            _rightBtn.positionType = CCPositionTypeNormalized;
            _rightBtn.anchorPoint = ccp(0.5, 0.5);
            _rightBtn.position = ccp(0.43, 0.1);
            [_rightBtn setTarget:self selector:@selector(clickRightButton)];
            [_itemPanel addChild:_rightBtn];
            
            _leftBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leftArrowButton.png"]];
            _leftBtn.positionType = CCPositionTypeNormalized;
            _leftBtn.anchorPoint = ccp(0.5, 0.5);
            _leftBtn.position = ccp(0.27, 0.1);
            [_leftBtn setTarget:self selector:@selector(clickLeftButton)];
            [_itemPanel addChild:_leftBtn];
        }
        
        _selectButton = [DefaultButton buttonWithTitle:@""];
        _selectButton.positionType = CCPositionTypeNormalized;
        _selectButton.anchorPoint = ccp(1, 0);
        _selectButton.position = ccp(0.73, 0.05);
        _selectButton.scale = 0.5;
        [_selectButton setTarget:self selector:@selector(selectItem)];
        [_itemPanel addChild:_selectButton];
        
        CCLabelTTF *labValueStr = [CCLabelTTF labelWithString:getLocalString(@"lab_equip_value") fontName:nil fontSize:12];
        labValueStr.positionType = CCPositionTypeNormalized;
        labValueStr.anchorPoint = ccp(0.5, 0.5);
        labValueStr.position = ccp(0.82, 0.312);
        [_itemPanel addChild:labValueStr];
        
        CCLabelTTF *labRelativeJob = [CCLabelTTF labelWithString:getLocalString(@"lab_relative_job") fontName:nil fontSize:12];
        labRelativeJob.positionType = CCPositionTypeNormalized;
        labRelativeJob.anchorPoint = ccp(0.5, 0.5);
        labRelativeJob.position = ccp(0.82, 0.5);
        [_itemPanel addChild:labRelativeJob];
        
        _labValue = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:12];
        _labValue.positionType = CCPositionTypeNormalized;
        _labValue.anchorPoint = ccp(0.5, 0.5);
        _labValue.position = ccp(0.82, 0.22);
        [_itemPanel addChild:_labValue];
        
        _labEquipType = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:12];
        _labEquipType.positionType = CCPositionTypeNormalized;
        _labEquipType.anchorPoint = ccp(0.5, 0.5);
        _labEquipType.position = ccp(0.82, 0.41);
        [_itemPanel addChild:_labEquipType];
        
        GameItemData *itemData = [[GameDataManager sharedGameData].itemDic objectForKey:itemId];
        if (_itemList) {
            _index = [_itemList indexOfObject:itemData];
            if (_itemList.count > 1) {
                _leftBtn.enabled = YES;
                _rightBtn.enabled = YES;
            } else {
                _leftBtn.enabled = NO;
                _rightBtn.enabled = NO;
            }
        } else {
            _leftBtn.enabled = NO;
            _rightBtn.enabled = NO;
        }
        [self setItemData:itemData];
    }
    return self;
}

-(void)setItemData:(GameItemData *)itemData
{
    if (_itemData != itemData) {
        _itemData = itemData;
        _labName.string = getItemName(itemData.itemId);
        _labDescription.string = getItemDescription(itemData.itemId);
        _labType.string = getItemType(itemData.itemData.type);
        
        if (itemData.itemData.type <= 3 && itemData.itemData.value > 0) {
            _labValue.string = [@(itemData.itemData.value) stringValue];
        } else {
            _labValue.string = @"-";
        }
        if (itemData.itemData.type == 3) {
            _labEquipType.string = getLocalStringByInt(@"job_name_", itemData.itemData.job);
        } else {
            _labEquipType.string = @"-";
        }
        
        if (_itemIcon != nil) {
            [_itemIcon removeFromParent];
        }
        _itemIcon = [[CCSprite alloc] initWithImageNamed:[NSString stringWithFormat:@"item%@.png", itemData.itemData.iconId]];
        [_itemIcon setRect:CGRectMake(191, 152, 56, 56)];
        [_itemPanel addChild:_itemIcon];
    }
    _index = [_itemList indexOfObject:itemData];
    // 这部分还是会刷新，因为可能情况变了
    if (_type == ItemBrowsePanelTypeBuy) {
        _selectButton.title = getLocalString(@"lab_buy");
        _selectButton.visible = YES;
    } else if (_type == ItemBrowsePanelTypeSell) {
        _selectButton.title = getLocalString(@"lab_sell");
        _selectButton.visible = YES;
    } else if (_type == ItemBrowsePanelTypeBrowse || _type == ItemBrowsePanelTypeSingle) {
        if (itemData.itemData.category <= ItemCategoryOtherEquip || itemData.itemData.type == ItemTypeShipHeader) {
            if (itemData.roleId || itemData.shipId) {
                _selectButton.title = getLocalString(@"lab_unequip");
            } else {
                _selectButton.title = getLocalString(@"lab_equip");
            }
            _selectButton.visible = YES;
        } else if (itemData.itemData.value > 0) {
            _selectButton.title = getLocalString(@"lab_use");
            _selectButton.visible = YES;
        } else {
            _selectButton.visible = NO;
        }
    } else if (_type == ItemBrowsePanelTypeEquip) {
        assert(self.equipedRoleId);
        if (itemData.roleId) {
            if ([self.equipedRoleId isEqualToString:itemData.roleId]) {
                _selectButton.title = getLocalString(@"lab_unequip");
            } else {
                _selectButton.title = getLocalString(@"lab_unequip_equip");
            }
        } else {
            _selectButton.title = getLocalString(@"lab_equip");
        }
        _selectButton.visible = YES;
    } else if (_type == ItemBrowsePanelTypeShipHeader) {
        if (itemData.shipId) {
            if ([self.equipedShipId isEqualToString:itemData.shipId]) {
                _selectButton.title = getLocalString(@"lab_unequip");
            } else {
                _selectButton.title = getLocalString(@"lab_unequip_equip");
            }
        } else {
            _selectButton.title = getLocalString(@"lab_equip");
        }
        _selectButton.visible = YES;
    }
}

-(void)clickCloseButton
{
    [self removeFromParent];
    self.completionBlockWithEventId(self.cancelEvent);
}

-(void)selectItem
{
    [self removeFromParent];
    self.completionBlockWithEventId(self.successEvent);
}

-(void)clickRightButton
{
    GameItemData *itemData = [_itemList objectAtIndex: (_index + 1) % _itemList.count];
    [[GameValueManager sharedValueManager] setReserveString:itemData.itemId byKey:ReservedItem];
    [self setItemData:itemData];
}

-(void)clickLeftButton
{
    GameItemData *itemData = [_itemList objectAtIndex: (_index - 1 + _itemList.count) % _itemList.count];
    [[GameValueManager sharedValueManager] setReserveString:itemData.itemId byKey:ReservedItem];
    [self setItemData:itemData];
}

@end
