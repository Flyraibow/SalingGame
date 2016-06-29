//
//  ShipdeckIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 4/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "ShipScene.h"
#import "RoleJobAnimation.h"

typedef enum : NSUInteger {
    ShipdeckTypeNone,
    ShipdeckTypeOperationSail,
    ShipdeckTypeLookout,
    ShipdeckTypeDeck,
    ShipdeckTypeSteerRoom,
    ShipdeckTypeCaptainRoom,
    ShipdeckTypeViseCaptainRoom,
    ShipdeckTypeFunctionRoom,
    ShipdeckTypeStorageRoom,
    ShipdeckTypeMeasureRoom,
} ShipdeckType;

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
    FunctionRoomEquipTypeCount,
} FunctionRoomEquipType;

@protocol ShipdeckIconSelectProtocol <NSObject>

-(void)selectShipdeckIcon:(id)shipdeckIcon;
-(int)nextShipdeckEquipType:(id)shipdeckIcon;
-(void)computeTimeAndMoney;

@end

@interface ShipdeckIcon : CCSprite

@property (nonatomic, assign) int roomId;
@property (nonatomic, readonly) NPCJobType job;
@property (nonatomic, weak) RoleJobAnimation *roleJobAnimation;
@property (nonatomic, weak) id<ShipdeckIconSelectProtocol> delegate;
@property (nonatomic, assign) BOOL canSelect;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, readonly, assign) DeckShipSceneType shipSceneType;
@property (nonatomic, readonly, assign) ShipdeckType shipDeckType;
@property (nonatomic, readonly, assign) int equipType;

-(instancetype)initWithShipdeckType:(ShipdeckType)shipType equipType:(int)equipType sceneType:(DeckShipSceneType)shipSceneType;

@end
