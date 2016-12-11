//
//  GameItemData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameItemData.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "GameNPCData.h"

static NSString* const GameItemCityNo = @"GameItemCityNo";
static NSString* const GameItemGuildNo= @"GameItemGuildNo";
static NSString* const GameItemRoleId= @"GameItemRoleId";
static NSString* const GameItemShipId= @"GameItemShipId";
static NSString* const GameItemItemId= @"GameItemItemId";

@implementation GameItemData

-(instancetype)initWithItemData:(ItemData *)itemData
{
    if (self = [super init]) {
        _itemData = itemData;
        _cityNo = itemData.ownerCityId;
        _guildId = itemData.ownerGuildId;
        _itemId = itemData.itemId;
        if ([_itemData.ownerCityId isEqualToString:@"0"] && [_itemData.ownerGuildId isEqualToString:@"0"]) {
            _exist = NO;
        } else {
            _exist = YES;
        }
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _cityNo = [aDecoder decodeObjectForKey:GameItemCityNo];
        _guildId = [aDecoder decodeObjectForKey:GameItemGuildNo];
        _roleId = [aDecoder decodeObjectForKey:GameItemRoleId];
        _shipId = [aDecoder decodeObjectForKey:GameItemShipId];
        _itemId = [aDecoder decodeObjectForKey:GameItemItemId];
        if ([_itemData.ownerCityId isEqualToString:@"0"] && [_itemData.ownerGuildId isEqualToString:@"0"]) {
            _exist = NO;
        } else {
            _exist = YES;
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_cityNo forKey:GameItemCityNo];
    [aCoder encodeObject:_guildId forKey:GameItemGuildNo];
    [aCoder encodeObject:_roleId forKey:GameItemRoleId];
    [aCoder encodeObject:_shipId forKey:GameItemShipId];
    [aCoder encodeObject:_itemId forKey:GameItemItemId];
}

-(void)boughtByGuildNo:(NSString *)guildNo
{
    _guildId = guildNo;
    _cityNo = @"0";
}

-(void)sellToCityNo:(NSString *)cityNo
{
    _cityNo = cityNo;
    _guildId = @"0";
    _roleId = nil;
    _shipId = nil;
}

-(void)isUsed
{
    _cityNo = @"0";
    _guildId = @"0";
}

-(BOOL)isEquiped
{
    return !!_roleId || !!_shipId;
}

-(NSString *)itemName
{
    return getItemName(_itemId);
}

-(void)unequip
{
    if (self.roleId) {
        GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:self.roleId];
        [npcData unequip:self];
    }
}

-(void)unequipShipheader
{
    GameShipData *shipData = [[GameDataManager sharedGameData].shipDic objectForKey:self.shipId];
    return [shipData unequip:self];
}

-(NSInteger)money
{
    return _itemData.price;
}

-(NSInteger)category
{
    return _itemData.category;
}

-(NSInteger)type
{
    return _itemData.type;
}

@end
