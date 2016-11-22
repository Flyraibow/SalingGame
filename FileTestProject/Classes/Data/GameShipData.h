//
//  GameShipData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipStyleData.h"
#import "ShipData.h"

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

typedef enum : NSUInteger {
    StorageRoomTypeNone,
    StorageRoomTypeFood,
    StorageRoomTypeGoods,
    StorageRoomTypeSailor,
    StorageRoomTypeCannon,
    StorageRoomTypeCount,
}StorageRoomType;

@class GameItemData;
@interface GameShipData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *shipId;
@property (nonatomic, readonly) NSString *shipStyleNo;
@property (nonatomic, readonly) NSString *shipIcon;
@property (nonatomic, copy) NSString *belongToGuild;
@property (nonatomic, copy) NSString *shipName;
@property (nonatomic, readonly) NSString *shipStyleName;

@property (nonatomic, readonly) int maxSailorNum;
@property (nonatomic, readonly) int minSailorNum;
@property (nonatomic, assign) int curSailorNum;
@property (nonatomic, readonly) int capacity;
@property (nonatomic) CGFloat foodCapacity;
@property (nonatomic, readonly) int maxFoodCapacity;
@property (nonatomic, readonly) int duration;
@property (nonatomic, readonly) int maxDuration;
@property (nonatomic, readonly) int agile;
@property (nonatomic, readonly) int speed;
@property (nonatomic, readonly) int cannonNum;
@property (nonatomic, assign) int cannonId;
@property (nonatomic, readonly) NSArray *goodsList;
@property (nonatomic, readonly) int price;
@property (nonatomic, strong) NSArray *equipList;
@property (nonatomic, readonly, weak) ShipStyleData *shipStyleData;
@property (nonatomic, readonly) int cannonRooms;
@property (nonatomic, readonly) NSString *shipIconImageName;
@property (nonatomic, copy) NSString *leaderName;
@property (nonatomic, copy) NSString *cityId;   // nil means it doesn't belong any city
@property (nonatomic, readonly) NSString *shipHeader;

-(instancetype)initWithShipStlyeData:(ShipStyleData *)shipStyleData;

-(instancetype)initWithShipData:(ShipData *)shipData;

-(void)equip:(GameItemData *)itemData;

-(void)unequip:(GameItemData *)itemData;

@end
