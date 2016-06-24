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
static NSString* const GameShipMaxSailorNum = @"GameShipMaxSailorNum";
static NSString* const GameShipMinSailorNum = @"GameShipMinSailorNum";
static NSString* const GameShipCurSailorNum = @"GameShipCurSailorNum";
static NSString* const GameShipCapacity = @"GameShipCapacity";
static NSString* const GameShipFoodCapacity = @"GameShipFoodCapacity";
static NSString* const GameShipMaxFoodCapacity = @"GameShipMaxFoodCapacity";
static NSString* const GameShipAgile = @"GameShipAgile";
static NSString* const GameShipSpeed = @"GameShipSpeed";
static NSString* const GameShipCannonId = @"GameShipCannonId";
static NSString* const GameShipCannonNum = @"GameShipCannonNum";
static NSString* const GameShipSpareRoom = @"GameShipSpareRoom";
static NSString* const GameShipDuration = @"GameShipDuration";
static NSString* const GameShipMaxDuration = @"GameShipMaxDuration";
static NSString* const GameShipGoodsList = @"GameShipGoodsList";
static NSString* const GameShipEquipList = @"GameShipEquipList";

@implementation GameShipData

-(instancetype)initWithShipData:(ShipData *)shipData
{
    if (self = [super init]) {
        _shipNo = shipData.shipId;
        _shipName = getLocalStringByString(@"ship_name_", _shipNo);
        _maxSailorNum = shipData.maxSailorNum;
        _minSailorNum = shipData.minSailorNum;
        _curSailorNum = 0;
        _capacity = shipData.capacity;
        _maxFoodCapacity = shipData.foodCapacity;
        _foodCapacity = 0;
        _agile = shipData.agile;
        _speed = shipData.speed;
        _cannonId = shipData.cannonId;
        _cannonNum = shipData.cannonNum;
        _spareRoom = shipData.spareRoomNum;
        _maxDuration = shipData.duration;
        _duration = _maxDuration;
        _goodsList = [NSMutableArray new];
        for (int i = 0; i < _capacity; ++i) {
            [_goodsList addObject:[GameShipGoodsData new]];
        }
        ShipStyleData *shipStyle = [[[DataManager sharedDataManager] getShipStyleDic] getShipStyleById:[@(shipData.style) stringValue]];
        _equipList = [shipStyle.equipList componentsSeparatedByString:@";"];
        _shipData = shipData;
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
        _maxSailorNum = [aDecoder decodeIntForKey:GameShipMaxSailorNum];
        _minSailorNum = [aDecoder decodeIntForKey:GameShipMinSailorNum];
        _curSailorNum = [aDecoder decodeIntForKey:GameShipCurSailorNum];
        _capacity = [aDecoder decodeIntForKey: GameShipCapacity];
        _foodCapacity = [aDecoder decodeIntForKey:GameShipFoodCapacity];
        _maxFoodCapacity = [aDecoder decodeIntForKey:GameShipMaxFoodCapacity];
        _agile = [aDecoder decodeIntForKey:GameShipAgile];
        _speed = [aDecoder decodeIntForKey:GameShipSpeed];
        _cannonId = [aDecoder decodeIntForKey:GameShipCannonId];
        _cannonNum = [aDecoder decodeIntForKey:GameShipCannonNum];
        _spareRoom = [aDecoder decodeIntForKey:GameShipSpareRoom];
        _duration = [aDecoder decodeIntForKey:GameShipDuration];
        _maxDuration = [aDecoder decodeIntForKey:GameShipMaxDuration];
        _goodsList = [aDecoder decodeObjectForKey:GameShipGoodsList];
        _shipData = [[[DataManager sharedDataManager] getShipDic] getShipById:_shipNo];
        _equipList = [aDecoder decodeObjectForKey:GameShipEquipList];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_shipNo forKey:GameShipNo];
    [aCoder encodeObject:_shipName forKey:GameShipName];
    [aCoder encodeObject:_belongToGuild forKey: GameShipBelongToGuild];
    [aCoder encodeInt:_maxSailorNum forKey:GameShipMaxSailorNum];
    [aCoder encodeInt:_minSailorNum forKey:GameShipMinSailorNum];
    [aCoder encodeInt:_curSailorNum forKey:GameShipCurSailorNum];
    [aCoder encodeInt:_capacity forKey:GameShipCapacity];
    [aCoder encodeInt:_foodCapacity forKey:GameShipFoodCapacity];
    [aCoder encodeInt:_maxFoodCapacity forKey:GameShipMaxFoodCapacity];
    [aCoder encodeInt:_agile forKey:GameShipAgile];
    [aCoder encodeInt:_speed forKey:GameShipSpeed];
    [aCoder encodeInt:_cannonId forKey:GameShipCannonId];
    [aCoder encodeInt:_cannonNum forKey:GameShipCannonNum];
    [aCoder encodeInt:_spareRoom forKey:GameShipSpareRoom];
    [aCoder encodeInt:_duration forKey:GameShipDuration];
    [aCoder encodeInt:_maxDuration forKey:GameShipMaxDuration];
    [aCoder encodeObject:_goodsList forKey:GameShipGoodsList];
    [aCoder encodeObject:_equipList forKey:GameShipEquipList];
}

-(NSString *)shipIcon
{
    return _shipData.icon;
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
