//
//  CityData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityData.h"

typedef enum : NSUInteger {
    InvestTypeCommerce,
    InvestTypeMilitary,
    InvestTypeSignup
} InvestType;

typedef enum : NSUInteger {
    CityOccupationChangeTypeInvest,
    CityOccupationChangeTypeRecommend,
    CityOccupationChangeTypeStory,
} CityOccupationChangeType;

typedef enum : NSUInteger {
    CityStateTypeNone,
    CityStateTypeNormal,
    CityStateTypeWell,
    CityStateTypePoor,
} CityStateType;

@interface GameCityData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *cityNo;
@property (nonatomic, readonly) CityStateType cityState;
@property (nonatomic, readonly) NSSet *buildingSet;
@property (nonatomic, readonly) NSMutableDictionary *goodsDict;
@property (nonatomic, readonly) NSMutableDictionary *boostDict;
@property (nonatomic, readonly) NSMutableDictionary *categoryPriceDict;
@property (nonatomic, readonly) NSMutableDictionary *goodsPriceDict;
@property (nonatomic, readonly) NSMutableSet *shipsSet;
@property (nonatomic, readonly, assign) int commerceValue;
@property (nonatomic, readonly, assign) int milltaryValue;
@property (nonatomic, readonly) NSMutableDictionary *transactionRecordDict;
@property (nonatomic, readonly) NSDictionary *guildOccupation;
@property (nonatomic, readonly) NSInteger commerceInvestRecord;
@property (nonatomic, readonly) NSInteger milltaryInvestRecord;
@property (nonatomic, readonly) NSDictionary *unlockGoodsDict;
@property (nonatomic, readonly, weak) CityData *cityData;

-(instancetype)initWithCityData:(CityData *)cityData;

-(void)addBuilding:(NSString *)buildingNo;

-(void)addGoods:(NSString *)goodsNo;

-(void)addShips:(NSString *)shipNo;

-(void)modifyBoost:(NSString *)goodsNo value:(int)boostValue;

-(int)getGoodsLevel:(NSString *)goodsId;

-(void)addTransactionRecord:(NSString *)guildId buyRecord:(NSDictionary *)buyRecords sellRecord:(NSDictionary *)sellRecords;

-(int)getGoodsNumForGuild:(NSString *)guildId goodsId:(NSString *)goodsId;

-(void)setOccupationForGuild:(NSString *)guildId percent:(int)percent;

-(void)addOccupationForGuild:(NSString *)guildId percent:(int)percent type:(CityOccupationChangeType)type;

-(void)investByGuild:(NSString *)guildId investUnits:(int)units money:(int)money type:(InvestType)type;

-(void)newMonth:(int)month;

-(BOOL)canSignUp:(NSString *)guildId;

-(int)getSalePriceForGoodsId:(NSString *)goodsId level:(int)level;

-(int)getBuyPriceForGoodsId:(NSString *)goodsId;

-(int)getBuyPriceForGoodsId:(NSString *)goodsId level:(int)level;

-(void)unlockGoodsByItem:(NSString *)itemId;

@end
