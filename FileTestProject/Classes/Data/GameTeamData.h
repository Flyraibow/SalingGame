//
//  GameTeamData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamData.h"

@interface GameTeamData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *teamId;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic) NSInteger teamMoney;
@property (nonatomic, readonly) NSMutableArray *shipList;
@property (nonatomic, readonly) NSString *belongToGuildId;
@property (nonatomic) NSString *currentCityId;
@property (nonatomic, assign) BOOL onTheSea;
@property (nonatomic, readonly) NSArray *npcList;

-(instancetype)initWithTeamData:(TeamData *)teamData guildId:(NSString *)guildId;

-(int)sailorNumbers;

-(CGFloat)needsFoodCapacity;

-(void)fillFood:(CGFloat)food;

-(void)addNpcId:(NSString *)npcId;

-(void)removeNpcId:(NSString *)npcId;

@end
