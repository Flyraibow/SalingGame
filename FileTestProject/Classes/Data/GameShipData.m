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
#import "GameItemData.h"
#import "GameDataManager.h"
#import "GameDataObserver.h"

static NSString* const GameShipId = @"GameShipId";
static NSString* const GameShipStyleNo = @"GameShipStyleNo";
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
static NSString* const GameShipCityId = @"GameShipCityId";
static NSString* const GameShipHeader = @"GameShipHeader";

@implementation GameShipData
{
    int _goodsRooms;
    int _foodRooms;
    int _sailorRooms;
}

-(instancetype)initWithShipStlyeData:(ShipStyleData *)shipStyleData
{
    if (self = [super init]) {
        _shipStyleNo = shipStyleData.shipStyleId;
        _shipStyleName = getLocalStringByString(@"ship_style_", _shipStyleNo);
        self.shipName = _shipStyleName;
        _shipStyleData = [[[DataManager sharedDataManager] getShipStyleDic] getShipStyleById:_shipStyleNo];
        _goodsList = [NSMutableArray new];
        self.equipList = [[_shipStyleData.equipList componentsSeparatedByString:@";"] mutableCopy];
        
        _curSailorNum = 0;
        _foodCapacity = 0;
        _agile = _shipStyleData.agile;
        _speed = _shipStyleData.speed;
        _cannonId = _shipStyleData.cannonId;
        _duration = self.maxDuration;
        _belongToGuild = nil;
        _leaderName = @"";
        _shipId = nil;
        _cityId = nil;
        
    }
    return self;
}

-(instancetype)initWithShipData:(ShipData *)shipData
{
    ShipStyleData *shipStyleData = [[DataManager sharedDataManager].getShipStyleDic getShipStyleById:shipData.style];
    if (self = [self initWithShipStlyeData:shipStyleData]) {
        _shipName = getLocalStringByString(@"ship_name_", shipData.shipId);
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _shipStyleNo = [aDecoder decodeObjectForKey:GameShipStyleNo];
        _shipName = [aDecoder decodeObjectForKey:GameShipName];
        _belongToGuild = [aDecoder decodeObjectForKey: GameShipBelongToGuild];
        _curSailorNum = [aDecoder decodeIntForKey:GameShipCurSailorNum];
        _foodCapacity = [aDecoder decodeDoubleForKey:GameShipFoodCapacity];
        _agile = [aDecoder decodeIntForKey:GameShipAgile];
        _speed = [aDecoder decodeIntForKey:GameShipSpeed];
        _cannonId = [aDecoder decodeIntForKey:GameShipCannonId];
        _duration = [aDecoder decodeIntForKey:GameShipDuration];
        _goodsList = [aDecoder decodeObjectForKey:GameShipGoodsList];
        _cityId = [aDecoder decodeObjectForKey:GameShipCityId];
        _shipId = [aDecoder decodeObjectForKey:GameShipId];
        _shipHeader = [aDecoder decodeObjectForKey:GameShipHeader];
        _shipStyleData = [[[DataManager sharedDataManager] getShipStyleDic] getShipStyleById:_shipStyleNo];
        self.equipList = [aDecoder decodeObjectForKey:GameShipEquipList];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_shipId forKey:GameShipId];
    [aCoder encodeObject:_shipStyleNo forKey:GameShipStyleNo];
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
    [aCoder encodeObject:_cityId forKey:GameShipCityId];
    [aCoder encodeObject:_shipHeader forKey:GameShipHeader];
}

-(NSString *)shipIcon
{
    return _shipStyleData.icon;
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
    return _shipStyleData.maxSailorNum + _sailorRooms * 80;
}

-(int)minSailorNum
{
    return _shipStyleData.minSailorNum + _cannonRooms * 30;
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
    return _shipStyleData.duration;
}

-(int)price
{
    if (self.belongToGuild == nil) {
        return _shipStyleData.price;
    } else {
        // TODO: 如果改造过，可能钱会些许不同
        return _shipStyleData.price * 0.6;
    }
}

-(NSString *)shipIconImageName
{
    return [NSString stringWithFormat:@"ship%@.png",self.shipIcon];
}


-(void)equip:(GameItemData *)itemData
{
    assert(itemData.itemData.type == ItemTypeShipHeader);
    if ([itemData.itemId isEqualToString:_shipHeader]) {
        return;
    }
    if (_shipHeader) {
        // 卸载原来的
        [self unequip:[[GameDataManager sharedGameData].itemDic objectForKey:_shipHeader]];
    }
    if (itemData.shipId) {
        GameShipData *shipData = [[GameDataManager sharedGameData].shipDic objectForKey:itemData.shipId];
        [shipData unequip:itemData];
    }
    itemData.shipId = self.shipId;
    _shipHeader = itemData.itemId;
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_SHIPHEADER data:self];
}

-(void)unequip:(GameItemData *)itemData
{
    assert(itemData.shipId == self.shipId);
    if (itemData.itemData.value == -1) {
    // 恶魔像，如果不是第一条船就可以拆除
        if ([[GameDataManager sharedGameData].myGuild.myTeam.shipList[0] isEqualToString:self.shipId]) {
            return ;
        }
        [[GameDataManager sharedGameData].myGuild.myTeam removeShip:self];
    }
    itemData.shipId = nil;
    _shipHeader = nil;
    [[GameDataObserver sharedObserver] sendListenerForKey:LISTENNING_KEY_SHIPHEADER data:self];
}

@end
