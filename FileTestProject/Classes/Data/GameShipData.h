//
//  GameShipData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipData.h"
#import "ShipStyleData.h"

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

@interface GameShipData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *shipNo;
@property (nonatomic, readonly) NSString *shipIcon;
@property (nonatomic, copy) NSString *belongToGuild;
@property (nonatomic) NSString *shipName;

@property (nonatomic, readonly) int maxSailorNum;
@property (nonatomic, readonly) int minSailorNum;
@property (nonatomic, readonly) int curSailorNum;
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
@property (nonatomic, readonly, weak) ShipData *shipData;
@property (nonatomic, readonly) int price;
@property (nonatomic, strong) NSArray *equipList;
@property (nonatomic, readonly, weak) ShipStyleData *shipStyleData;
@property (nonatomic, readonly) int cannonRooms;
@property (nonatomic, readonly) NSString *shipIconImageName;
@property (nonatomic, copy) NSString *leaderName;


-(instancetype)initWithShipData:(ShipData *)shipData;

@end
