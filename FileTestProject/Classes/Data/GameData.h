//
//  GameData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyGuild.h"
#import "DateUpdateProtocol.h"
#import "OccupationUpdateProtocol.h"
#import "CityChangeProtocol.h"

typedef enum : NSUInteger {
    ChangeValueTypeEqual,
    ChangeValueTypeAdd,
    ChangeValueTypeMinus,
    ChangeValueTypeMultiply,
    ChangeValueTypeDivide,
    ChangeValueTypeExpression,
} ChangeValueType;

@interface GameDialogData : NSObject

@property (nonatomic) NSString *portrait;
@property (nonatomic) NSString *npcName;
@property (nonatomic) NSString *text;

@end

@class GameShipData;
@interface GameData : NSObject <NSCoding>

@property (nonatomic, readonly) NSDictionary *cityDic;
@property (nonatomic, readonly) NSDictionary *npcDic;
@property (nonatomic, readonly) NSDictionary *guildDic;
@property (nonatomic, readonly) NSDictionary *logicData;
@property (nonatomic, readonly) NSDictionary *storyLockData;
@property (nonatomic, readonly) int year;
@property (nonatomic, readonly) int month;
@property (nonatomic, readonly) int day;
@property (nonatomic) MyGuild *myGuild;
@property (nonatomic, readonly) NSMutableArray *dialogList;   // 临时对话
@property (nonatomic, copy) NSString *currentMusic;
@property (nonatomic, readonly) NSDictionary *itemDic;
@property (nonatomic, readonly) NSMutableDictionary<NSString *, GameShipData *> *shipDic;

-(void)initGuildData;

-(void)initMyGuildWithGameGuildData:(GameGuildData *)guildData;

-(NSString *)getLogicData:(NSString *)logicId;

-(void)setSpecialLogical:(NSString *)logicName parameter2:(NSString *)parameter2 parameter3:(NSString *)parameter3 parameter4:(NSString *)parameter4;

-(void)setLogicDataWithLogicId:(NSString *)logicId value:(NSString *)logicValue changeValueType:(ChangeValueType)type;

-(void)setStoryLockWithStoryId:(NSString *)storyId locked:(BOOL)locked;

-(void)removeLogicDataWithLogicId:(NSString *)logicId;

-(void)setYear:(int)year month:(int)month day:(int)day;

-(NSString *)getDateStringWithYear:(BOOL)wy;

-(void)spendOneDay;

-(void)spendOneDayWithInterval:(CGFloat)interval callback:(void(^)())handler;

-(void)moveToCity:(NSString *)cityNo;

-(void)removeTimeUpdateClass:(id)target;

-(void)addTimeUpdateClass:(id<DateUpdateProtocol>)target;

-(void)removeTimeUpdateClass:(id)target;

-(void)addOccupationUpdateClass:(id<OccupationUpdateProtocol>)target;

-(void)removeOccupationUpdateClass:(id)target;

-(void)sendOccupationUpdateInfo:(NSString *)cityNo data:(NSMutableDictionary *)dict;

-(void)addCityChangeClass:(id<CityChangeProtocol>)target;

-(void)removeCityChangeClass:(id)target;

-(NSArray *)itemListByCity:(NSString *)cityId;

-(NSArray *)itemListByGuild:(NSString *)guildId;

-(void)registerGameShipData:(GameShipData *)gameShipData;

@end
