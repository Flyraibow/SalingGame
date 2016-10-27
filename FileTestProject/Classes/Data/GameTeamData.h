//
//  GameTeamData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamData.h"

@class GameShipData;
@class GameNPCData;
@interface GameTeamData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *teamId;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic) NSInteger teamMoney;
@property (nonatomic, readonly) NSArray<NSString *> *shipList;
@property (nonatomic, readonly) NSString *belongToGuildId;
@property (nonatomic) NSString *currentCityId;
@property (nonatomic, assign) BOOL onTheSea;
@property (nonatomic, readonly) NSArray<GameNPCData *> *npcList;
@property (nonatomic, readonly) NSArray<NSString *> *carryShipList; // 拖船

-(instancetype)initWithTeamData:(TeamData *)teamData guildId:(NSString *)guildId;

-(int)sailorNumbers;
-(int)needSailorNumbersWithNewHiring:(int)newSailorsNum;
-(CGFloat)totalFood;

-(CGFloat)needsFoodCapacity;

-(void)fillFood:(CGFloat)food;

-(void)addNpcId:(NSString *)npcId;

-(void)removeNpcId:(NSString *)npcId;

// 获取船只，如果船只多于5条，将会把船寄放到这个城市的船坞
-(void)getShip:(GameShipData *)shipData cityId:(NSString *)cityId;
-(void)removeShip:(GameShipData *)shipData;
-(void)removeShip:(GameShipData *)shipData forEver:(BOOL)forever;

-(NSArray *)getCarryShipListInCity:(NSString *)cityId;

-(NSMutableArray<GameShipData *> *)shipDataList;

-(NSMutableArray<GameShipData *> *)carryShipDataList;

-(CGFloat)getTeamSpeed;

@end
