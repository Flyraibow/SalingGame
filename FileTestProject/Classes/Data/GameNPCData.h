//
//  NPCData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

typedef enum : NSUInteger {
    NPCJobTypeNone,
    NPCJobTypeCaptain,
    NPCJobTypeOperatingSail,
    NPCJobTypeLookout,
    NPCJobTypeDeck,
    NPCJobTypeCalibration,
    NPCJobTypeSteerRoom,
    NPCJobTypeViseCaptain,
    NPCJobTypeChargeCaptain,
    NPCJobTypeCannon,
    NPCJobTypeCarpenter,
    NPCJobTypeDoctor,
    NPCJobTypeChef,
    NPCJobTypeRaiser,
    NPCJobTypePriest,
    NPCJobTypeThinker,
    NPCJobTypeAccounter,
    NPCJobTypeSecondCaptain,
    NPCJobTypeRelax,
} NPCJobType;

@interface GameSkillData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *skillId;
@property (nonatomic, assign) int currentExp;
@property (nonatomic, assign) int level;
@property (nonatomic, weak) NSString *skillListStr;

-(instancetype)initWithSkillId:(NSString *)skillId level:(int)level;

@end

@class GameGuildData;
@class GameTeamData;
@interface GameNPCData : NSObject <NSCoding>

@property (nonatomic, assign) int level;
@property (nonatomic, copy) NSString *npcId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) int strength;
@property (nonatomic, assign) int agile;
@property (nonatomic, assign) int eloquence;
@property (nonatomic, assign) int charm;
@property (nonatomic, assign) int luck;
@property (nonatomic, assign) int intelligence;
@property (nonatomic) NSDictionary* skillDataDict;
@property (nonatomic, readonly, weak) NpcData *npcData;
@property (nonatomic, weak) GameGuildData *guildData;
@property (nonatomic, weak) GameTeamData *teamData;
@property (nonatomic, readonly, assign) int maxHp;
@property (nonatomic, assign) int currHp;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *portrait;
@property (nonatomic, assign) BOOL isCaptain;
@property (nonatomic, assign) NPCJobType job;
@property (nonatomic, readonly) int roomId;

-(instancetype)initWithNpcId:(NSString *)npcId;

@end
