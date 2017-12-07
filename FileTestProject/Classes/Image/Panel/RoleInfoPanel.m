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
#import "RoleAnimation.h"
#import "GameDataObserver.h"

@interface RoleInfoPanel() <ItemIconSelectionDelegate, NSCopying>

@end

@implementation RoleInfoPanel
{
  CCSprite *_roleInfoPanel;
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
  CCLabelTTF *_labJobTitle;
  CCLabelTTF *_labHPMax;
  CCLabelTTF *_labHPCurrent;
  __weak GameNPCData *_npcData;
  ItemInfoPanel *_itemPanel;
  CCLabelTTF *_labLevel;
  CCLabelTTF *_labBodyStatus;
  CCLabelTTF *_labMoodStatus;
  RoleAnimation *_roleAnimation;
  CCDrawNode *_attributeGraph;            // 六方图
}

-(instancetype)init
{
  if (self = [super init]) {
    _roleInfoPanel = [[CCSprite alloc] initWithImageNamed:@"RoleInfoPanel.jpg"];
    _roleInfoPanel.positionType = CCPositionTypeNormalized;
    _roleInfoPanel.anchorPoint = ccp(0.5, 1);
    _roleInfoPanel.position = ccp(0.5, 1);
    [self addChild:_roleInfoPanel];
    _roleInfoPanel.scale = MIN(_roleInfoPanel.contentSize.width / self.contentSize.width, _roleInfoPanel.contentSize.height / self.contentSize.height);
    
    DefaultButton *closeButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
    closeButton.scale = 0.5;
    closeButton.anchorPoint = ccp(1,0);
    closeButton.positionType = CCPositionTypePoints;
    closeButton.position = ccp(_roleInfoPanel.contentSize.width - 10, 10);
    [closeButton setTarget:self selector:@selector(clickCloseButton)];
    [_roleInfoPanel addChild:closeButton];
    
    _labNpcName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
    _labNpcName.positionType = CCPositionTypeNormalized;
    _labNpcName.anchorPoint = ccp(0,1);
    _labNpcName.position = ccp(0.22, 0.95);
    [_roleInfoPanel addChild:_labNpcName];
    
    _labGender = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
    _labGender.positionType = CCPositionTypeNormalized;
    _labGender.anchorPoint=ccp(0,1);
    _labGender.position = ccp(0.715, 0.765);
    [_roleInfoPanel addChild:_labGender];
    
    _labStrength = [CCLabelTTF labelWithString:getLocalString(@"lab_strength") fontName:nil fontSize:12];
    _labStrength.positionType = CCPositionTypePoints;
    _labStrength.position = ccp(504, 225);
    [_roleInfoPanel addChild:_labStrength];
    
    _labIntelligence = [CCLabelTTF labelWithString:getLocalString(@"lab_intelligence") fontName:nil fontSize:12];
    _labIntelligence.positionType = CCPositionTypePoints;
    _labIntelligence.position = ccp(602, 225);
    [_roleInfoPanel addChild:_labIntelligence];
    
    _labEloquence = [CCLabelTTF labelWithString:getLocalString(@"lab_eloquence") fontName:nil fontSize:12];
    _labEloquence.positionType = CCPositionTypePoints;
    _labEloquence.position = ccp(613, 185);
    [_roleInfoPanel addChild:_labEloquence];
    
    _labCharm = [CCLabelTTF labelWithString:getLocalString(@"lab_charm") fontName:nil fontSize:12];
    _labCharm.positionType = CCPositionTypePoints;
    _labCharm.position = ccp(602, 145);
    [_roleInfoPanel addChild:_labCharm];
    
    _labLuck = [CCLabelTTF labelWithString:getLocalString(@"lab_luck") fontName:nil fontSize:12];
    _labLuck.positionType = CCPositionTypePoints;
    _labLuck.position = ccp(506, 145);
    [_roleInfoPanel addChild:_labLuck];
    
    _labAgile = [CCLabelTTF labelWithString:getLocalString(@"lab_agile") fontName:nil fontSize:12];
    _labAgile.positionType = CCPositionTypePoints;
    _labAgile.position = ccp(493, 185);
    [_roleInfoPanel addChild:_labAgile];
    
    _labJobTitle = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
    _labJobTitle.positionType = CCPositionTypeNormalized;
    _labJobTitle.anchorPoint = ccp(0,1);
    _labJobTitle.position = ccp(0.25, 0.86);
    [_roleInfoPanel addChild:_labJobTitle];
    
    CCLabelTTF *labHp = [CCLabelTTF labelWithString:getLocalString(@"lab_hp") fontName:nil fontSize:14];
    labHp.positionType = CCPositionTypeNormalized;
    labHp.anchorPoint=ccp(0,1);
    labHp.position = ccp(0.25, 0.765);
    [_roleInfoPanel addChild:labHp];
    
    _labHPMax = [CCLabelTTF labelWithString:@"0" fontName:nil fontSize:14];
    _labHPMax.positionType = CCPositionTypeNormalized;
    _labHPMax.anchorPoint=ccp(0,1);
    _labHPMax.position = ccp(0.405, 0.765);
    [_roleInfoPanel addChild:_labHPMax];
    
    _labHPCurrent = [CCLabelTTF labelWithString:@"0" fontName:nil fontSize:14];
    _labHPCurrent.positionType = CCPositionTypeNormalized;
    _labHPCurrent.anchorPoint=ccp(1,1);
    _labHPCurrent.position = ccp(0.375, 0.765);
    [_roleInfoPanel addChild:_labHPCurrent];
    
    _labLevel = [CCLabelTTF labelWithString:getLocalString(@"") fontName:nil fontSize:14];
    _labLevel.positionType = CCPositionTypeNormalized;
    _labLevel.anchorPoint=ccp(0,1);
    _labLevel.position = ccp(0.22, 0.625);
    [_roleInfoPanel addChild:_labLevel];
    
    _labBodyStatus = [CCLabelTTF labelWithString:getLocalString(@"") fontName:nil fontSize:14];
    _labBodyStatus.positionType = CCPositionTypeNormalized;
    _labBodyStatus.anchorPoint=ccp(0.5,1);
    _labBodyStatus.position = ccp(0.62, 0.86);
    [_roleInfoPanel addChild:_labBodyStatus];
    
    _labMoodStatus = [CCLabelTTF labelWithString:getLocalString(@"") fontName:nil fontSize:14];
    _labMoodStatus.positionType = CCPositionTypeNormalized;
    _labMoodStatus.anchorPoint=ccp(0.5,1);
    _labMoodStatus.position = ccp(0.62, 0.77);
    [_roleInfoPanel addChild:_labMoodStatus];
    
    _roleAnimation = [[RoleAnimation alloc] init];
    _roleAnimation.positionType = CCPositionTypeNormalized;
    _roleAnimation.anchorPoint = ccp(0.5, 0.5);
    _roleAnimation.position = ccp(0.2, 0.80);
    [_roleInfoPanel addChild:_roleAnimation];
    
    _weaponIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(30, 30)];
    _weaponIcon.delegate = self;
    _weaponIcon.itemCategory = ItemCategoryWeapon;
    _weaponIcon.positionType = CCPositionTypePoints;
    _weaponIcon.position = ccp(257, 145);
    [_roleInfoPanel addChild:_weaponIcon];
    
    _armorIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(30, 30)];
    _armorIcon.delegate = self;
    _armorIcon.itemCategory = ItemCategoryArmor;
    _armorIcon.positionType = CCPositionTypePoints;
    _armorIcon.position = ccp(297, 145);
    [_roleInfoPanel addChild:_armorIcon];
    
    NSMutableArray *otherEquipIconList = [NSMutableArray new];
    for (int i = 0; i < 3; ++i) {
      ItemIcon *otherIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(30, 30)];
      otherIcon.delegate = self;
      otherIcon.itemCategory = ItemCategoryOtherEquip;
      otherIcon.positionType = CCPositionTypePoints;
      otherIcon.position = ccp(344 + i * 40.5, 145);
      [otherEquipIconList addObject:otherIcon];
      [_roleInfoPanel addChild:otherIcon];
    }
    _otherEquipIconList = otherEquipIconList;
    
    _attributeGraph = [[CCDrawNode alloc] init];
    _attributeGraph.positionType = CCPositionTypePoints;
    _attributeGraph.position = ccp(552, 184);
    [_roleInfoPanel addChild:_attributeGraph];
    
    [[GameDataObserver sharedObserver] addListenerForKey:LISTENNING_KEY_EQUIP target:self selector:@selector(setRoleId:)];
  }
  return self;
}

-(id)copyWithZone:(NSZone *)zone
{
  return self;
}

-(void)removeAllChildrenWithCleanup:(BOOL)cleanup
{
  [[GameDataObserver sharedObserver] removeAllListenersForTarget:self];
  [super removeAllChildrenWithCleanup:cleanup];
}

-(void)setRoleId:(NSString *)roleId
{
  if(![_roleId isEqualToString:roleId])
  {
    _roleId = roleId;
    _npcData = [[GameDataManager sharedGameData].npcDic objectForKey:roleId];
    _roleAnimation.roleId = roleId;
    _roleAnimation.job = _npcData.job;
    _labNpcName.string = _npcData.fullName;
    _labJobTitle.string = _npcData.jobTitle;
    if(_photo != nil) {
      [_roleInfoPanel removeChild:_photo];
    }
    _photo = [CCSprite spriteWithImageNamed:_npcData.portrait];
    [_photo setRect:CGRectMake(25, 154, 78, 95)];
    [_roleInfoPanel addChild:_photo];
    
    _labGender.string = getLocalStringByInt(@"gender_", _npcData.npcInfo.gender + 1);
    [self drawAttributeGraph];
  }
  if (_npcData.weaponId) {
    [_weaponIcon setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:_npcData.weaponId]];
  } else {
    [_weaponIcon setItemData:nil];
  }
  if (_npcData.armorId) {
    [_armorIcon setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:_npcData.armorId]];
  } else {
    [_armorIcon setItemData:nil];
  }
  for (int i = 0; i < _npcData.otherEquipIdList.count; ++i) {
    [_otherEquipIconList[i] setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:_npcData.otherEquipIdList[i]]];
  }
  for (NSUInteger i = _npcData.otherEquipIdList.count; i < 3; ++i) {
    [_otherEquipIconList[i] setItemData:nil];
  }
  _labHPCurrent.string = [@(_npcData.currHp) stringValue];
  _labHPMax.string = [@(_npcData.maxHp) stringValue];
  _labLevel.string = [NSString stringWithFormat:getLocalString(@"lab_npc_level"), _npcData.level];
  _labMoodStatus.string = getLocalStringByInt(@"mood_status_", _npcData.moodStatus);
  _labBodyStatus.string = getLocalStringByInt(@"body_status_", _npcData.bodyStatus);
}

-(void)clickCloseButton
{
  if (self.delegate != nil) {
    [self.delegate closePanel];
  } else {
    [self removeFromParent];
  }
}


-(void)selectItem:(GameItemData *)itemData
{
  // 弹出商品info，可以选择卸载
  [self.delegate selectItem:itemData];
}


-(void)selectItemByCategory:(ItemCategory)itemCategory
{
  [self.delegate selectItemCategory:itemCategory];
  // 弹出选择商品列表，可以装备
  //    NSArray *items = [[GameDataManager sharedGameData] itemListByGuild:[GameDataManager sharedGameData].myGuild.guildId];
  //    NSMutableArray *mutableItems = [items mutableCopy];
  //    // 删除不和条件的类型
  //    for (GameItemData *itemData in items) {
  //        if (itemData.itemData.category != itemCategory) {
  //            [mutableItems removeObject:itemData];
  //        }
  //    }
  //    ItemBrowsePanel *panel = [[ItemBrowsePanel alloc] initWithItems:mutableItems panelType:ItemBrowsePanelTypeEquip];
  //    panel.delegate = self;
  //    panel.equipedRoleId = _roleId;
  //    [self.scene addChild:panel];
}


-(void)drawAttributeGraph
{
  [_attributeGraph clear];
  if (_npcData != nil) {
    CGPoint points[6];
    CGFloat scale = 0.38;
    points[0].x = - MAX(_npcData.strength, 100) * 0.6 * scale;
    points[0].y = MAX(_npcData.strength, 100) * scale;
    points[1].x = MAX(_npcData.intelligence, 100) * 0.6 * scale;
    points[1].y = MAX(_npcData.intelligence, 100) * scale;
    points[2].x = MAX(_npcData.eloquence, 100) * scale;
    points[2].y = 0;
    points[3].x = MAX(_npcData.charm, 100) * 0.6 * scale;
    points[3].y = - MAX(_npcData.charm, 100) * scale;
    points[4].x = - MAX(_npcData.luck, 100) * 0.6 * scale;
    points[4].y = - MAX(_npcData.luck, 100) * scale;
    points[5].x = - MAX(_npcData.agile, 100) * scale;
    points[5].y = 0;
    [_attributeGraph drawPolyWithVerts:points count:6 fillColor:[CCColor cyanColor] borderWidth:1.0 borderColor:[CCColor greenColor]];
  }
}

@end

