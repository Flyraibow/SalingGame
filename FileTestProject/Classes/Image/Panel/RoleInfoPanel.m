//
//  RoleInfoPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RoleInfoPanel.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "GameNPCData.h"
#import "CCSprite+Ext.h"
#import "GameDataManager.h"
#import "ItemIcon.h"
#import "ItemBrowsePanel.h"
#import "ItemInfoPanel.h"
#import "SpriteUpdateProtocol.h"

@interface RoleInfoPanel() <ItemIconSelectionDelegate, ItemInfoPanelDelegate, SpriteUpdateProtocol>

@end

@implementation RoleInfoPanel
{
    CCLabelTTF *_labNpcName;
    CCSprite *_photo;
    ItemIcon *_weaponIcon;
    ItemIcon *_armorIcon;
    NSArray<ItemIcon *> *_otherEquipIconList;
    CCLabelTTF *_labGender;
    CCLabelTTF *_labLuck;
    CCLabelTTF *_labStrength;
    CCLabelTTF *_labAgile;
    CCLabelTTF *_labCharm;
    CCLabelTTF *_labIntelligence;
    CCLabelTTF *_labEloquence;
    __weak GameNPCData *_npcData;
    ItemInfoPanel *_itemPanel;
}

-(instancetype)init
{
    if (self = [super initWithImageNamed:@"RoleInfoPanel.jpg"]) {
        self.positionType = CCPositionTypeNormalized;
        self.anchorPoint = ccp(0.5, 1);
        self.position = ccp(0.5, 1);
        
        DefaultButton *closeButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        closeButton.scale = 0.5;
        closeButton.anchorPoint = ccp(1,0);
        closeButton.positionType = CCPositionTypePoints;
        closeButton.position = ccp(self.contentSize.width - 10, 10);
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        [self addChild:closeButton];
        
        _labNpcName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labNpcName.positionType = CCPositionTypeNormalized;
        _labNpcName.anchorPoint = ccp(0,1);
        _labNpcName.position = ccp(0.22, 0.95);
        [self addChild:_labNpcName];
        
        _labGender = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labGender.positionType = CCPositionTypeNormalized;
        _labGender.anchorPoint=ccp(0,1);
        _labGender.position = ccp(0.715, 0.765);
        [self addChild:_labGender];
        
        _labStrength = [CCLabelTTF labelWithString:getLocalString(@"lab_strength") fontName:nil fontSize:12];
        _labStrength.positionType = CCPositionTypePoints;
        _labStrength.position = ccp(504, 225);
        [self addChild:_labStrength];
        
        _labIntelligence = [CCLabelTTF labelWithString:getLocalString(@"lab_intelligence") fontName:nil fontSize:12];
        _labIntelligence.positionType = CCPositionTypePoints;
        _labIntelligence.position = ccp(602, 225);
        [self addChild:_labIntelligence];
        
        _labEloquence = [CCLabelTTF labelWithString:getLocalString(@"lab_eloquence") fontName:nil fontSize:12];
        _labEloquence.positionType = CCPositionTypePoints;
        _labEloquence.position = ccp(613, 185);
        [self addChild:_labEloquence];
        
        _labCharm = [CCLabelTTF labelWithString:getLocalString(@"lab_charm") fontName:nil fontSize:12];
        _labCharm.positionType = CCPositionTypePoints;
        _labCharm.position = ccp(602, 145);
        [self addChild:_labCharm];
        
        _labLuck = [CCLabelTTF labelWithString:getLocalString(@"lab_luck") fontName:nil fontSize:12];
        _labLuck.positionType = CCPositionTypePoints;
        _labLuck.position = ccp(506, 145);
        [self addChild:_labLuck];
        
        _labAgile = [CCLabelTTF labelWithString:getLocalString(@"lab_agile") fontName:nil fontSize:12];
        _labAgile.positionType = CCPositionTypePoints;
        _labAgile.position = ccp(493, 185);
        [self addChild:_labAgile];
        
        _weaponIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(30, 30)];
        _weaponIcon.delegate = self;
        _weaponIcon.itemCategory = ItemCategoryWeapon;
        _weaponIcon.positionType = CCPositionTypePoints;
        _weaponIcon.position = ccp(257, 145);
        [self addChild:_weaponIcon];
        
        _armorIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(30, 30)];
        _armorIcon.delegate = self;
        _armorIcon.itemCategory = ItemCategoryArmor;
        _armorIcon.positionType = CCPositionTypePoints;
        _armorIcon.position = ccp(297, 145);
        [self addChild:_armorIcon];
        
        NSMutableArray *otherEquipIconList = [NSMutableArray new];
        for (int i = 0; i < 3; ++i) {
            ItemIcon *otherIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(30, 30)];
            otherIcon.delegate = self;
            otherIcon.itemCategory = ItemCategoryArmor;
            otherIcon.positionType = CCPositionTypePoints;
            otherIcon.position = ccp(344 + i * 40.5, 145);
            [otherEquipIconList addObject:otherIcon];
            [self addChild:otherIcon];
        }
        _otherEquipIconList = otherEquipIconList;

    }
    
    return self;
}


-(void)setRoleId:(NSString *)roleId
{
    if(![_roleId isEqualToString:roleId])
    {
        _roleId = roleId;
        _npcData = [[GameDataManager sharedGameData].npcDic objectForKey:roleId];
                
        _labNpcName.string = _npcData.fullName;
        if(_photo != nil)
            [self removeChild:_photo];
        _photo = [CCSprite spriteWithImageNamed:_npcData.portrait];
        [_photo setRect:CGRectMake(25, 154, 78, 95)];
        [self addChild:_photo];
        
        _labGender.string = getLocalStringByInt(@"gender_", _npcData.npcData.gender + 1);
    }
    if (_npcData.weaponId) {
        [_weaponIcon setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:_npcData.weaponId]];
    } else {
        // TODO: SET NIL
        [_weaponIcon setItemData:nil];
    }
    if (_npcData.armorId) {
        [_armorIcon setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:_npcData.armorId]];
    }
    for (int i = 0; i < _npcData.otherEquipIdList.count; ++i) {
        [_otherEquipIconList[i] setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:_npcData.otherEquipIdList[i]]];
    }
}

-(void)clickCloseButton
{
    [self.delegate closePanel];
}


-(void)selectItem:(GameItemData *)itemData
{
    // 弹出商品info，可以选择卸载
    _itemPanel = [[ItemInfoPanel alloc] initWithPanelType:ItemBrowsePanelTypeSingle];
    [_itemPanel setItemData:itemData];
    _itemPanel.delegate = self;
    [self.scene addChild:_itemPanel];
}

-(void)selectItemFromInfoPanel:(GameItemData *)gameItemData
{
    // 更新
    [_npcData unequip:gameItemData];
    [self setRoleId:_roleId];
    if (_itemPanel) {
        [_itemPanel removeFromParent];
    }
}

-(void)selectItemByCategory:(ItemCategory)itemCategory
{
    // 弹出选择商品列表，可以装备
    NSMutableArray *items = [[[GameDataManager sharedGameData] itemListByGuild:[GameDataManager sharedGameData].myGuild.guildId] mutableCopy];
    // 删除不和条件的类型
    for (GameItemData *itemData in items) {
        if (itemData.itemData.category != itemCategory) {
            [items removeObject:itemData];
        }
    }
    ItemBrowsePanel *panel = [[ItemBrowsePanel alloc] initWithItems:items panelType:ItemBrowsePanelTypeEquip];
    panel.delegate = self;
    panel.equipedRoleId = _roleId;
    [self.scene addChild:panel];
}

-(void)updatePanel
{
    [self setRoleId:_roleId];
}

@end
