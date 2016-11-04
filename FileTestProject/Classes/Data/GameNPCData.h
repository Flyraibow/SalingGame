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
    NPCBodyStatusNull,
    NPCBodyStatusNormal,
} NPCBodyStatus;

typedef enum : NSUInteger {
    NPCMoodStatusNull,
    NPCMoodStatusNormal,
} NPCMoodStatus;

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
    NPCJobTypeCounselor,
    NPCJobTypeAccounter,
    NPCJobTypeSecondCaptain,
    NPCJobTypeRelax,
} NPCJobType;

typedef enum : NSUInteger {
    NPCEquipErrorNone,  // 可以装备
    NPCEquipErrorFull,  // 已经装备满了
} NPCEquipError;

@interface GameSkillData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *skillId;
@property (nonatomic, assign) int currentExp;
@property (nonatomic, assign) int level;
@property (nonatomic, weak) NSString *skillListStr;

-(instancetype)initWithSkillId:(NSString *)skillId level:(int)level;

@end

@class GameGuildData;
@class GameTeamData;
@class GameItemData;
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
@property (nonatomic, readonly) NSString *jobTitle;
@property (nonatomic, readonly) NSString *portrait;
@property (nonatomic, assign) BOOL isCaptain;
@property (nonatomic, assign) NPCJobType job;
@property (nonatomic, assign) int roomId;
@property (nonatomic, copy) NSString *weaponId;
@property (nonatomic, copy) NSString *armorId;
@property (nonatomic, copy) NSArray *otherEquipIdList;
@property (nonatomic, readonly) NPCBodyStatus bodyStatus;
@property (nonatomic, readonly) NPCMoodStatus moodStatus;


-(instancetype)initWithNpcId:(NSString *)npcId;

-(BOOL)isableTodo:(NPCJobType)job;

// 0: 可以装备, 1：请先卸掉其他的装备
-(NPCEquipError)canEquip:(GameItemData *)itemData;

-(void)equip:(GameItemData *)itemData;

-(void)unequip:(GameItemData *)itemData;

@end
