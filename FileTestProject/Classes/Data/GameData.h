//
//  GameData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGuild.h"

typedef enum : NSUInteger {
  ChangeValueTypeEqual,
  ChangeValueTypeAdd,
  ChangeValueTypeMinus,
  ChangeValueTypeMultiply,
  ChangeValueTypeDivide,
  ChangeValueTypeExpression,
} ChangeValueType;

typedef enum : NSUInteger {
  CityNear                = 1,
  CityFaraway             = 1 << 1,
  CityCapital             = 1 << 2,
  CityDifferentGoods      = 1 << 3,
  CitySameOwner           = 1 << 4,
  CityWithShop            = 1 << 5,
} CitySearchCondition;

@interface GameDialogData : NSObject

@property (nonatomic) NSString *portrait;
@property (nonatomic) NSString *npcName;
@property (nonatomic) NSString *text;

@end

@class GameShipData;
@class GameCityData;
@class GameTeamData;
@interface GameData : NSObject <NSCoding>

@property (nonatomic, readonly) NSDictionary<NSString *, GameCityData *> *cityDic;
@property (nonatomic, readonly) NSDictionary *npcDic;
@property (nonatomic, readonly) NSDictionary *guildDic;
@property (nonatomic, readonly) NSDictionary<NSString *, GameTeamData *> *teamDic;
@property (nonatomic, readonly) NSDictionary *storyLockData;
@property (nonatomic, readonly) int year;
@property (nonatomic, readonly) int month;
@property (nonatomic, readonly) int day;
@property (nonatomic, readonly) NSInteger date;
@property (nonatomic) MyGuild *myGuild;
@property (nonatomic, readonly) NSMutableArray *dialogList;   // 临时对话
@property (nonatomic, copy) NSString *currentMusic;
@property (nonatomic, readonly) NSDictionary<NSString *, GameItemData *> *itemDic;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, GameShipData *> *shipDic;

-(void)initGuildData;

-(void)initMyGuildWithGameGuildData:(GameGuildData *)guildData;

-(NSString *)getLogicData:(NSString *)logicId;

-(void)setSpecialLogical:(NSString *)logicName parameter2:(NSString *)parameter2 parameter3:(NSString *)parameter3 parameter4:(NSString *)parameter4;

-(void)setLogicDataWithLogicId:(NSString *)logicId value:(NSString *)logicValue changeValueType:(ChangeValueType)type;

-(void)setStoryLockWithStoryId:(NSString *)storyId locked:(BOOL)locked;

-(void)setYear:(int)year month:(int)month day:(int)day;

-(NSString *)getDateStringWithYear:(BOOL)wy;

-(void)spendOneDay;

-(void)moveToCity:(NSString *)cityNo;

-(NSArray *)itemListByCity:(NSString *)cityId;

-(NSArray *)itemListByGuild:(NSString *)guildId;

-(BOOL)containsItem:(NSString *)itemId guildId:(NSString *)guildId;

-(void)registerGameShipData:(GameShipData *)gameShipData;

-(void)dataChangeWithTerm:(NSString *)term;

-(GameCityData *)randomCityFromCity:(GameCityData *)cityData
                          condition:(CitySearchCondition)condition;

@end

