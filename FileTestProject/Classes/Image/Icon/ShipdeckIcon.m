//
//  ShipdeckIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipdeckIcon.h"

typedef enum : NSUInteger {
    FunctionRoomEquipTypeLiving,
    FunctionRoomEquipTypeCarpenter,
    FunctionRoomEquipTypeDoctor,
    FunctionRoomEquipTypeCooking,
    FunctionRoomEquipTypeDancing,
    FunctionRoomEquipTypeFeeding,
    FunctionRoomEquipTypePraying,
    FunctionRoomEquipTypeStrategy,
    FunctionRoomEquipTypeAccouting,
} FunctionRoomEquipType;

@implementation ShipdeckIcon
{
    DeckShipSceneType _shipSceneType;
}

-(instancetype)initWithShipdeckType:(ShipdeckType)shipType
                          equipType:(int)equipType
                          sceneType:(DeckShipSceneType)shipSceneType
{
    _shipSceneType = shipSceneType;
    NSString *shipdeckStr;
    if (equipType == 0) {
        // 如果该房间为原生态
        shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd.png", shipType];
    } else {
        // 如果该房间已经被改造过了，某些图标在甲板界面的时候还是按照原本的显示，但是在改造界面上则需要修改
        if (shipSceneType == DeckShipSceneModify || shipType == ShipdeckTypeFunctionRoom || shipType == ShipdeckTypeStorageRoom) {
            shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd_%d.png", shipType, equipType];
        } else {
            shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd.png", shipType];
        }
    }
    if (self = [super initWithImageNamed:shipdeckStr]) {
        // TODO: 如果是可以改造的，且现在是改造模式则 显示选择框
        if (shipSceneType == DeckShipSceneDeck) {
            [self initJob:shipType equipType:equipType];
        }
    }
    return self;
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (_shipSceneType == DeckShipSceneModify) {
        // TODO：检查是否能修改，可能需要用到delegate 从上面检查
        // 如果成功则更换房间样式，注：只是暂时的，最后确定的时候才会正式换。
    }
}

-(void)setRoleJobAnimation:(RoleJobAnimation *)roleJobAnimation
{
    if (_roleJobAnimation == nil) {
        [self addChild:roleJobAnimation];
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
                default:
                    break;
            }
            break;
        }
    }
}

@end
