//
//  GameTeamData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamData.h"

typedef enum : NSUInteger {
    CheckShipResultSuccess,
    CheckShipResultNoShips,
    CheckShipResultNoSailors,
    CheckShipResultNoFoods,
    CheckShipResultNeedRepair
} CheckShipResult;

@interface GameTeamData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *teamId;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic, readonly) NSInteger teamMoney;
@property (nonatomic, readonly) NSMutableArray *shipList;
@property (nonatomic, readonly) NSString *belongToGuildId;
@property (nonatomic) NSString *currentCityId;
@property (nonatomic, assign) BOOL onTheSea;
@property (nonatomic, readonly) NSArray *npcList;

-(instancetype)initWithTeamData:(TeamData *)teamData guildId:(NSString *)guildId;

-(CheckShipResult)checkShips;

-(void)addNpcId:(NSString *)npcId;

-(void)removeNpcId:(NSString *)npcId;

@end
