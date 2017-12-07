//
//  GameTeamData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamData.h"
#import "BaseData.h"

extern const int TEAM_MAX_SHIP_NUMBER;

@class GameShipData;
@class GameNPCData;
@interface GameTeamData : BaseData <NSCoding>

@property (nonatomic, readonly) NSString *teamId;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic, readonly) NSString *teamLabel;
@property (nonatomic) NSInteger teamMoney;
@property (nonatomic, readonly) NSArray<NSString *> *shipList;
@property (nonatomic, readonly) NSString *belongToGuildId;
@property (nonatomic) NSString *currentCityId;
@property (nonatomic) NSString *currentBuildingNo;
@property (nonatomic, assign) BOOL onTheSea;
@property (nonatomic, readonly) NSArray<GameNPCData *> *npcList;
@property (nonatomic, readonly) NSArray<NSString *> *carryShipList; // 拖船
@property (nonatomic, readonly) CGPoint pos;

@property (nonatomic, readonly) NSInteger shipNumber;
@property (nonatomic, readonly) NSInteger haveSailors;
@property (nonatomic, readonly) NSInteger haveEnoughSailors;
@property (nonatomic, readonly) NSInteger canSailDays;

-(instancetype)initWithTeamData:(TeamData *)teamData guildId:(NSString *)guildId;

-(int)sailorNumber;
-(int)maxSailorNumber;
-(int)needSailorNumber;
-(int)needSailorNumbersWithNewHiring:(int)newSailorsNum;

-(NSInteger)needsFoodCapacity;

-(void)fillFood:(NSInteger)food;

-(void)addNpcId:(NSString *)npcId;

-(void)removeNpcId:(NSString *)npcId;

// 获取船只，如果船只多于5条，将会把船寄放到这个城市的船坞
-(void)getShip:(GameShipData *)shipData cityId:(NSString *)cityId;
-(void)removeShip:(GameShipData *)shipData;

-(NSArray *)getCarryShipListInCity:(NSString *)cityId;

-(NSMutableArray<GameShipData *> *)shipDataList;

-(NSMutableArray<GameShipData *> *)carryShipDataList;

-(CGFloat)getTeamSpeed;

-(NSString *)relationToGuild:(NSString *)guildId;

@end
