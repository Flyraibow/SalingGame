//
//  ShipdeckIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipdeckIcon.h"

@implementation ShipdeckIcon
{
    CCSprite *_selectableSprite;
    CCSprite *_selectedSprite;
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
    if (_equipType == 0) {
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
                    _job = NPCJobTypeThinker;
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
            }
            break;
        }
    }
}

@end
