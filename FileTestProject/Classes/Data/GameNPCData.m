//
//  NPCData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameNPCData.h"
#import "LocalString.h"

@implementation GameSkillData

static NSString* const SkillDataId = @"SkillDataId";
static NSString* const SkillDataLevel = @"SkillDataLevel";
static NSString* const SkillDataExp = @"SkillDataExp";

-(instancetype)initWithSkillId:(NSString *)skillId level:(int)level
{
    if (self = [self init]) {
        self.skillId = skillId;
        self.level = level;
        _currentExp = 0;
        _skillListStr = [[[DataManager sharedDataManager] getSkillDic] getSkillById:skillId].exp;
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _skillId = [aDecoder decodeObjectForKey:SkillDataId];
        _level = [aDecoder decodeIntForKey:SkillDataLevel];
        _currentExp = [aDecoder decodeIntForKey:SkillDataExp];
        _skillListStr = [[[DataManager sharedDataManager] getSkillDic] getSkillById:_skillId].exp;
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_skillId forKey:SkillDataId];
    [aCoder encodeInt:_level forKey:SkillDataLevel];
    [aCoder encodeInt:_currentExp forKey:SkillDataExp];
}

@end


@implementation GameNPCData

static NSString* const GameNPCId = @"GameNPCId";
static NSString* const NPCLevel = @"NPCLevel";
static NSString* const NPCFirstName = @"NPCFirstName";
static NSString* const NPCLastName = @"NPCLastName";
static NSString* const NPCStrength = @"NPCStrength";
static NSString* const NPCAgile = @"NPCAgile";
static NSString* const NPCIntelligence = @"NPCIntelligence";
static NSString* const NPCCharm = @"NPCCharm";
static NSString* const NPCLuck = @"NPCLuck";
static NSString* const NPCEloquence = @"NPCEloquence";
static NSString* const NPCSkills = @"NPCSkills";
static NSString* const NPCJob = @"NPCJob";
static NSString* const NPCIsCaptain = @"NPCIsCaptain";
static NSString* const NPCRoomId = @"NPCRoomId";
static NSString* const NPCMaxHP = @"NPCMaxHP";
static NSString* const NPCCurrentHP = @"NPCCurrentHP";


-(instancetype)initWithNpcId:(NSString *)npcId
{
    if (self = [self init]) {
        _npcData = [[[DataManager sharedDataManager] getNpcDic] getNpcById:npcId];
        _npcId = npcId;
        _level = _npcData.level;
        _firstName = getNpcFirstName(npcId);
        _lastName = getNpcLastName(npcId);
        _strength = _npcData.strength;
        _agile = _npcData.agile;
        _charm = _npcData.charm;
        _intelligence = _npcData.intelligence;
        _luck = _npcData.luck;
        _eloquence = _npcData.eloquence;
        _maxHp = _npcData.hp;
        _currHp = _maxHp;
        _isCaptain = NO;
        NSMutableDictionary *skillDataDict = [NSMutableDictionary new];
        NSArray *skillArray = [_npcData.skillList componentsSeparatedByString:@";"];
        for (NSString *skillStr in skillArray) {
            if (skillStr.length > 0) {
                NSString *skillId = [skillStr componentsSeparatedByString:@"_"][0];
                int skillLevel = [skillStr componentsSeparatedByString:@"_"][1];
                GameSkillData * gameSkill = [[GameSkillData alloc] initWithSkillId:skillId level:skillLevel];
                [skillDataDict setObject:gameSkill forKey:skillId];
            }
        }
        _skillDataDict = skillDataDict;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _npcId = [aDecoder decodeObjectForKey:GameNPCId];
        _level = [aDecoder decodeIntForKey:NPCLevel];
        _firstName = [aDecoder decodeObjectForKey:NPCFirstName];
        _lastName = [aDecoder decodeObjectForKey:NPCLastName];
        _strength = [aDecoder decodeIntForKey:NPCStrength];
        _charm = [aDecoder decodeIntForKey:NPCCharm];
        _agile = [aDecoder decodeIntForKey:NPCAgile];
        _luck = [aDecoder decodeIntForKey:NPCLuck];
        _eloquence = [aDecoder decodeIntForKey:NPCEloquence];
        _intelligence = [aDecoder decodeIntForKey:NPCIntelligence];
        _skillDataDict = [aDecoder decodeObjectForKey:NPCSkills];
        _isCaptain = [aDecoder decodeBoolForKey:NPCIsCaptain];
        _job = [aDecoder decodeIntegerForKey:NPCJob];
        _roomId = [aDecoder decodeIntForKey:NPCRoomId];
        _maxHp = [aDecoder decodeIntForKey:NPCMaxHP];
        _currHp = [aDecoder decodeIntForKey:NPCCurrentHP];
        
        _npcData = [[[DataManager sharedDataManager] getNpcDic] getNpcById:_npcId];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_npcId forKey:GameNPCId];
    [aCoder encodeInt:_level forKey:NPCLevel];
    [aCoder encodeObject:_firstName forKey:NPCFirstName];
    [aCoder encodeObject:_lastName forKey:NPCLastName];
    [aCoder encodeInt:_strength forKey:NPCStrength];
    [aCoder encodeInt:_agile forKey:NPCAgile];
    [aCoder encodeInt:_luck forKey:NPCLuck];
    [aCoder encodeInt:_eloquence forKey:NPCEloquence];
    [aCoder encodeInt:_intelligence forKey:NPCIntelligence];
    [aCoder encodeInt:_charm forKey:NPCCharm];
    [aCoder encodeInt:_skillDataDict forKey:NPCSkills];
    [aCoder encodeBool:_isCaptain forKey:NPCIsCaptain];
    [aCoder encodeInteger:_job forKey:NPCJob];
    [aCoder encodeInt:_roomId forKey:NPCRoomId];
    [aCoder encodeInt:_maxHp forKey:NPCMaxHP];
    [aCoder encodeInt:_currHp forKey:NPCCurrentHP];
}

-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ · %@",self.firstName, self.lastName];
}

-(NSString *)portrait
{
    return [NSString stringWithFormat:@"dialogPortrait%@.png", self.npcData.dialogPotraitId];
}


-(BOOL)isableTodo:(NPCJobType)job
{
    if (job == NPCJobTypeNone) {
        return NO;
    } else if (job == NPCJobTypeCaptain) {
        return _isCaptain;
    }
    return YES;
}

@end
