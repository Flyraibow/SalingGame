//
//  ShipdeckIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipdeckIcon.h"
#import "ItemBrowsePanel.h"
#import "GameDataManager.h"
#import "ItemIcon.h"
#import "CCSprite+Ext.h"
#import "ItemInfoPanel.h"
#import "GamePanelManager.h"

@interface ShipdeckIcon() <SpriteUpdateProtocol>

@end

@implementation ShipdeckIcon
{
    CCSprite *_selectableSprite;
    CCSprite *_selectedSprite;
    ItemIcon *_headerIcon;
    ItemInfoPanel *_itemPanel;
}

-(instancetype)initWithShipdeckType:(ShipdeckType)shipType
                          equipType:(int)equipType
                          sceneType:(DeckShipSceneType)shipSceneType
{
    _shipSceneType = shipSceneType;
    _shipDeckType = shipType;
    _equipType = equipType;
    NSString *shipdeckStr = [self shipiconString];
    if (self = [super initWithImageNamed:shipdeckStr]) {
        _selectableSprite = [CCSprite spriteWithImageNamed:@"Shipdeck_select.png"];
        _selectableSprite.positionType = CCPositionTypeNormalized;
        _selectableSprite.position = ccp(0.5, 0.5);
        _selectableSprite.visible = NO;
        [self addChild:_selectableSprite];
        self.canSelect = NO;

        // TODO: 如果是可以改造的，且现在是改造模式则 显示选择框
        if (shipSceneType == DeckShipSceneDeck) {
            [self initJob:shipType equipType:equipType];
            _selectedSprite = [CCSprite spriteWithImageNamed:@"Shipdeck_selected.png"];
            _selectedSprite.positionType = CCPositionTypeNormalized;
            _selectedSprite.position = ccp(0.5, 0.5);
            _selectedSprite.visible = NO;
            [self addChild:_selectedSprite];
        } else if (shipSceneType == DeckShipSceneModify) {
            if (shipType == ShipdeckTypeFunctionRoom || shipType == ShipdeckTypeStorageRoom) {
                self.canSelect = YES;
            } else if (shipType == ShipdeckTypeDeck) {
                //如果是甲板
                if (equipType == 0) {
                    _equipType = self.shipData.shipHeader;
                    self.canSelect = YES;
                    _headerIcon = [[ItemIcon alloc] initWithContentSize:CGSizeMake(48, 48)];
                    _headerIcon.positionType = CCPositionTypeNormalized;
                    _headerIcon.anchorPoint = ccp(0.5, 0.5);
                    _headerIcon.position = ccp(0.5, 0.5);
                    _headerIcon.userInteractionEnabled = NO;
                    [self addChild:_headerIcon];
                }
            }
        }
        
        self.selected = NO;
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(NSString *)shipiconString
{
    NSString *shipdeckStr;
    if (_equipType <= 0) {
        // 如果该房间为原生态
        shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd.png", _shipDeckType];
    } else {
        // 如果该房间已经被改造过了，某些图标在甲板界面的时候还是按照原本的显示，但是在改造界面上则需要修改
        if (_shipSceneType == DeckShipSceneModify || _shipDeckType == ShipdeckTypeFunctionRoom || _shipDeckType == ShipdeckTypeStorageRoom) {
            shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd_%d.png", _shipDeckType, _equipType];
        } else {
            shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd.png", _shipDeckType];
        }
    }
    return shipdeckStr;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (_shipSceneType == DeckShipSceneModify) {
        // TODO：检查是否能修改，可能需要用到delegate 从上面检查
        if (self.canSelect) {
            if (_shipDeckType != ShipdeckTypeDeck) {
                int equipType = [_delegate nextShipdeckEquipType:self];
                if (equipType != _equipType) {
                    _equipType = equipType;
                    NSString *shipdeckStr = [self shipiconString];
                    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:shipdeckStr]];
                    [_delegate computeTimeAndMoney];
                }
            } else {
                // 船首像的逻辑另外算
                if (self.shipData.shipHeader) {
                    // 弹出商品info，可以选择卸载
//                    _itemPanel = [[ItemInfoPanel alloc] initWithPanelType:ItemBrowsePanelTypeSingle];
//                    [_itemPanel setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:self.shipData.shipHeader]];
//                    _itemPanel.delegate = self;
//                    [self.scene addChild:_itemPanel];
                    
                } else {
                    NSArray *items = [[GameDataManager sharedGameData] itemListByGuild:[GameDataManager sharedGameData].myGuild.guildId];
                    NSMutableArray *mutableItems = [items mutableCopy];
                    // 删除不和条件的类型
                    for (GameItemData *itemData in items) {
                        if (itemData.itemData.type != ItemTypeShipHeader) {
                            [mutableItems removeObject:itemData];
                        }
                    }
//                    ItemBrowsePanel *itemPanel = [[ItemBrowsePanel alloc] initWithItems:mutableItems panelType:ItemBrowsePanelTypeShipHeader];
//                    itemPanel.delegate = self;
//                    itemPanel.equipedShipId = self.shipData.shipId;
//                    [self.scene addChild:itemPanel];
                }
            }
        }
        // 如果成功则更换房间样式，注：只是暂时的，最后确定的时候才会正式换。
    } else if (_shipSceneType == DeckShipSceneDeck) {
        if (self.canSelect) {
            [_delegate selectShipdeckIcon:self];
        }
    }
}

-(void)setCanSelect:(BOOL)canSelect
{
    if (_canSelect != canSelect) {
        _canSelect = canSelect;
        _selectableSprite.visible = canSelect;
    }
}

-(void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        _selectedSprite.visible = selected;
    }
}

-(void)setRoleJobAnimation:(RoleJobAnimation *)roleJobAnimation
{
    if ((_roleJobAnimation != roleJobAnimation)) {
        if (_roleJobAnimation && _roleJobAnimation.parent == self) {
            _roleJobAnimation.roomId = 0;
            _roleJobAnimation.job = NPCJobTypeNone;
            [_roleJobAnimation removeFromParent];
        }
        if (roleJobAnimation) {
            if (roleJobAnimation.parent) {
                [roleJobAnimation removeFromParent];
            }
            roleJobAnimation.roomId = _roomId;
            roleJobAnimation.job = _job;
            [self addChild:roleJobAnimation];
        }
        _roleJobAnimation = roleJobAnimation;
    } else if (roleJobAnimation == nil) {
        if (_roleJobAnimation && _roleJobAnimation.parent == self) {
            _roleJobAnimation.roomId = 0;
            _roleJobAnimation.job = NPCJobTypeNone;
            [_roleJobAnimation removeFromParent];
        }
    }
}

-(void)initJob:(ShipdeckType)shipType
     equipType:(int)equipType
{
    _job = NPCJobTypeNone;
    switch (shipType) {
        case ShipdeckTypeNone:
        case ShipdeckTypeStorageRoom:
            break;
        case ShipdeckTypeDeck:
            _job = NPCJobTypeDeck;
            break;
        case ShipdeckTypeLookout:
            _job = NPCJobTypeLookout;
            break;
        case ShipdeckTypeSteerRoom:
            _job = NPCJobTypeSteerRoom;
            break;
        case ShipdeckTypeCaptainRoom:
            _job = NPCJobTypeCaptain;
            break;
        case ShipdeckTypeOperationSail:
            _job = NPCJobTypeOperatingSail;
            break;
        case ShipdeckTypeViseCaptainRoom:
            _job = NPCJobTypeViseCaptain;
            break;
        case ShipdeckTypeMeasureRoom:
            _job = NPCJobTypeCalibration;
            break;
        case ShipdeckTypeFunctionRoom:
        {
            switch ((FunctionRoomEquipType)equipType) {
                case FunctionRoomEquipTypeDoctor:
                    _job = NPCJobTypeDoctor;
                    break;
                case FunctionRoomEquipTypeCooking:
                    _job = NPCJobTypeChef;
                    break;
                case FunctionRoomEquipTypeFeeding:
                    _job = NPCJobTypeRaiser;
                    break;
                case FunctionRoomEquipTypePraying:
                    _job = NPCJobTypePriest;
                    break;
                case FunctionRoomEquipTypeStrategy:
                    _job = NPCJobTypeCounselor;
                    break;
                case FunctionRoomEquipTypeAccouting:
                    _job = NPCJobTypeAccounter;
                    break;
                case FunctionRoomEquipTypeCarpenter:
                    _job = NPCJobTypeCarpenter;
                    break;
                case FunctionRoomEquipTypeLiving:
                case FunctionRoomEquipTypeDancing:
                    _job = NPCJobTypeRelax;
                    break;
                default:
                    break;
            }
            break;
        }
    }
}

-(void)setShipData:(GameShipData *)shipData
{
    _shipData = shipData;
    // 显示船首像
    [self updatePanel];;
}

-(void)updatePanel
{
    // 只有船首像才需要这种更新
    if (_shipSceneType == DeckShipSceneModify && _shipDeckType == ShipdeckTypeDeck && _equipType == 0) {
        if (self.shipData.shipHeader) {
            [_headerIcon setItemData:[[GameDataManager sharedGameData].itemDic objectForKey:self.shipData.shipHeader]];
        } else {
            [_headerIcon setItemData:nil];
        }
    }
}


-(void)selectItemFromInfoPanel:(GameItemData *)gameItemData
{
    // 更新 ShipUnequipError err = ShipUnequipErrorNone;
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self];
    ShipUnequipError err = ShipUnequipErrorNone;
    void(^uneuquipSuccess)(BOOL closePanel) = ^(BOOL closePanel){
        [dialogPanel setDefaultDialog:@"dialog_unequip_a_shipheader" arguments:nil];
        [dialogPanel addConfirmHandler:^{
            [self updatePanel];
            if (_itemPanel) {
                [_itemPanel removeFromParent];
            }
            if (closePanel) {
                [[CCDirector sharedDirector] popScene];
                [self.delegate shipDestroyed];
            }
        }];
    };
    if ((err = [gameItemData unequipShipheader]) == ShipUnequipErrorNone) {
        uneuquipSuccess(NO);
    } else if (err == ShipUnequipErrorDemon) {
        //弹出提示，拆除会损坏船只是否强行拆除
        [dialogPanel setDefaultDialog:@"dialog_cannot_unequip_a_shipheader_demon" arguments:nil];
        [dialogPanel addYesNoWithCallback:^(int index) {
            if (index == 0) {
                ShipUnequipError error;
                if ((error = [gameItemData unequipShipheaderWithForce:YES]) == ShipUnequipErrorNone) {
                    uneuquipSuccess(YES);
                } else if (error == ShipUnequipErrorDemonFirst) {
                    [dialogPanel setDefaultDialog:@"dialog_cannot_unequip_a_shipheader_demon_first" arguments:nil];
                }
            }
        }];
    }
}

@end
