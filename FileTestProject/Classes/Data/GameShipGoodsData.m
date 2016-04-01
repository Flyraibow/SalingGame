//
//  GameShipGoodsData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameShipGoodsData.h"

@implementation GameShipGoodsData

static NSString* const GameShipGoodsId = @"GameShipGoodsId";
static NSString* const GameShipGoodsPrice = @"GameShipGoodsPrice";
static NSString* const GameShipGoodsLevel = @"GameShipGoodsLevel";


-(instancetype)initWithGoodsId:(NSString *)goodsId price:(int)price level:(int)level
{
    self = [self init];
    if (self) {
        _goodsId = goodsId;
        _price = price;
        _level = level;
    }
    return self;
}


-(void)setGoodsId:(NSString *)goodsId price:(int)price level:(int)level
{
    _goodsId = goodsId;
    _price = price;
    _level = level;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _goodsId = [aDecoder decodeObjectForKey:GameShipGoodsId];
        _price = [aDecoder decodeIntForKey: GameShipGoodsPrice];
        _level = [aDecoder decodeIntForKey:GameShipGoodsLevel];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_goodsId forKey:GameShipGoodsId];
    [aCoder encodeInt:_price forKey:GameShipGoodsPrice];
    [aCoder encodeInt:_level forKey:GameShipGoodsLevel];
}

@end
