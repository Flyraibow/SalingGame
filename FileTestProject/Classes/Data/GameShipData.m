//
//  GameShipData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameShipData.h"
#import "DataManager.h"
#import "LocalString.h"
#import "GameShipGoodsData.h"

static NSString* const GameShipNo = @"GameShipNo";
static NSString* const GameShipName = @"GameShipName";
static NSString* const GameShipBelongToGuild = @"GameShipBelongToGuild";
static NSString* const GameShipCurSailorNum = @"GameShipCurSailorNum";
static NSString* const GameShipFoodCapacity = @"GameShipFoodCapacity";
static NSString* const GameShipAgile = @"GameShipAgile";
static NSString* const GameShipSpeed = @"GameShipSpeed";
static NSString* const GameShipCannonId = @"GameShipCannonId";
static NSString* const GameShipDuration = @"GameShipDuration";
static NSString* const GameShipGoodsList = @"GameShipGoodsList";
static NSString* const GameShipEquipList = @"GameShipEquipList";

@implementation GameShipData
{
    int _goodsRooms;
    int _foodRooms;
    int _sailorRooms;
}

-(instancetype)initWithShipData:(ShipData *)shipData
{
    if (self = [super init]) {
        _shipNo = shipData.shipId;
        _shipName = getLocalStringByString(@"ship_name_", _shipNo);
        
        _shipData = shipData;
        _shipStyleData = [[[DataManager sharedDataManager] getShipStyleDic] getShipStyleById:[@(shipData.style) stringValue]];
        _goodsList = [NSMutableArray new];
        self.equipList = [[_shipStyleData.equipList componentsSeparatedByString:@";"] mutableCopy];
        
        _curSailorNum = 0;
        _foodCapacity = 0;
        _agile = shipData.agile;
        _speed = shipData.speed;
        _cannonId = shipData.cannonId;
        _duration = self.maxDuration;
        _belongToGuild = nil;
        
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _shipNo = [aDecoder decodeObjectForKey:GameShipNo];
        _shipName = [aDecoder decodeObjectForKey:GameShipName];
        _belongToGuild = [aDecoder decodeObjectForKey: GameShipBelongToGuild];
        _curSailorNum = [aDecoder decodeIntForKey:GameShipCurSailorNum];
        _foodCapacity = [aDecoder decodeDoubleForKey:GameShipFoodCapacity];
        _agile = [aDecoder decodeIntForKey:GameShipAgile];
        _speed = [aDecoder decodeIntForKey:GameShipSpeed];
        _cannonId = [aDecoder decodeIntForKey:GameShipCannonId];
        _duration = [aDecoder decodeIntForKey:GameShipDuration];
        _goodsList = [aDecoder decodeObjectForKey:GameShipGoodsList];
        _shipData = [[[DataManager sharedDataManager] getShipDic] getShipById:_shipNo];
        _shipStyleData = [[[DataManager sharedDataManager] getShipStyleDic] getShipStyleById:[@(_shipData.style) stringValue]];
        self.equipList = [aDecoder decodeObjectForKey:GameShipEquipList];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_shipNo forKey:GameShipNo];
    [aCoder encodeObject:_shipName forKey:GameShipName];
    [aCoder encodeObject:_belongToGuild forKey: GameShipBelongToGuild];
    [aCoder encodeInt:_curSailorNum forKey:GameShipCurSailorNum];
    [aCoder encodeDouble:_foodCapacity forKey:GameShipFoodCapacity];
    [aCoder encodeInt:_agile forKey:GameShipAgile];
    [aCoder encodeInt:_speed forKey:GameShipSpeed];
    [aCoder encodeInt:_cannonId forKey:GameShipCannonId];
    [aCoder encodeInt:_duration forKey:GameShipDuration];
    [aCoder encodeObject:_goodsList forKey:GameShipGoodsList];
    [aCoder encodeObject:_equipList forKey:GameShipEquipList];
}

-(NSString *)shipIcon
{
    return _shipData.icon;
}

-(void)setEquipList:(NSArray *)equipList
{
    int foodCapacity = 0;
    int goodsCapacity = 0;
    int sailorRooms = 0;
    int cannonRooms = 0;
    NSArray *roomList = [_shipStyleData.roomList componentsSeparatedByString:@";"];
    for (int i = 0; i < roomList.count; ++i) {
        NSString *info = roomList[i];
        if (info.length > 0) {
            NSArray *infoList = [info componentsSeparatedByString:@"_"];
            int shipdeckType = [infoList[0] intValue];
            int equipType =[equipList[i] intValue];
            if (shipdeckType == ShipdeckTypeStorageRoom) {
                if (equipType == StorageRoomTypeGoods) {
                    goodsCapacity++;
                } else if (equipType == StorageRoomTypeFood) {
                    foodCapacity++;
                } else if (equipType == StorageRoomTypeSailor) {
                    sailorRooms++;
                } else if (equipType == StorageRoomTypeCannon) {
                    cannonRooms++;
                }
            }
        }
    }
    _foodCapacity = MAX(foodCapacity, _foodCapacity);
    if (_goodsList.count > goodsCapacity) {
        [(NSMutableArray *)_goodsList removeObjectsInRange:NSMakeRange(goodsCapacity, _goodsList.count - goodsCapacity)];
    }
    for (NSInteger i = _goodsList.count; i < goodsCapacity; ++i) {
        [(NSMutableArray *)_goodsList addObject:[GameShipGoodsData new]];
    }
    _goodsRooms = goodsCapacity;
    _cannonRooms = cannonRooms;
    _sailorRooms = sailorRooms;
    _foodRooms = foodCapacity;
    
    _equipList = equipList;
}

-(int)maxSailorNum
{
    return _shipData.maxSailorNum + _sailorRooms * 80;
}

-(int)minSailorNum
{
    return _shipData.minSailorNum + _cannonRooms * 30;
}

-(int)capacity
{
    return _goodsRooms;
}

-(int)maxFoodCapacity
{
    return _foodRooms;
}

-(int)cannonNum
{
    return _cannonRooms * 24 + 2;
}

-(int)maxDuration
{
    return _shipData.duration;
}

-(int)price
{
    if (self.belongToGuild == nil) {
        return _shipData.price;
    } else {
        // TODO: 如果改造过，可能钱会些许不同
        return _shipData.price * 0.6;
    }
}

@end
