//
//  GuildData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameGuildData.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "GameTeamData.h"

@implementation GameGuildData

static NSString* const GameGuildMoney = @"GameGuildMoney";
static NSString* const GameGuildId = @"GameGuildId";
static NSString* const GameGuildName = @"GameGuildName";
static NSString* const GameGuildLeaderId = @"GameGuildLeaderId";
static NSString* const GameGuildCityControlDic = @"GameGuildCityControlDic";
static NSString* const GameGuildTeamList = @"GameGuildTeamList";
static NSString* const GameGuildCityKnowledgeSet = @"GameGuildCityKnowledgeSet";

-(instancetype)initWithGuildData:(GuildData *)guildData
{
    if (self = [super init]) {
        _guildId = guildData.guildId;
        _teamList = [NSMutableArray new];
        _leaderId = guildData.guildId;
        NSArray *teamArray = [guildData.teamList componentsSeparatedByString:@";"];
        for (int i = 0; i < teamArray.count; ++i) {
            NSString *teamId = teamArray[i];
            if (teamId.length > 0) {
                GameTeamData *teamData = [[GameTeamData alloc] initWithTeamData:[[DataManager sharedDataManager].getTeamDic getTeamById:teamId] guildId:_guildId];
                [_teamList addObject:teamData];
            }
        }
        
        _cityControlDic = [NSMutableDictionary new];
        _cityKnowledgeSet = [NSMutableSet new];
        if (guildData != nil) {
            _guildId = guildData.guildId;
            _money = guildData.money;
            
            NSArray *cityArray = [guildData.cityList componentsSeparatedByString:@";"];
            NSArray *occupationArray = [guildData.occupationList componentsSeparatedByString:@";"];
            for (int i = 0; i < cityArray.count; ++i) {
                NSString *cityNo = cityArray[i];
                [_cityControlDic setObject:occupationArray[i] forKey:cityNo];
                GameCityData *gameCityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
                [gameCityData setOccupationForGuild:_guildId percent:[occupationArray[i] intValue]];
                [_cityKnowledgeSet addObject:cityNo];
            }
        }
    }
    return self;
}

-(instancetype)initWithGameGuildData:(GameGuildData *)guildData
{
    if (self = [super init]) {
        _guildId = guildData.guildId;
        _guildName = guildData.guildName;
        _money = guildData.money;
        _cityControlDic = guildData.cityControlDic;
        _leaderId = guildData.leaderId;
        _teamList = guildData.teamList;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _guildId = [aDecoder decodeObjectForKey:GameGuildId];
        self.money = [aDecoder decodeIntegerForKey: GameGuildMoney];
        _guildName = [aDecoder decodeObjectForKey:GameGuildName];
        _cityControlDic = [aDecoder decodeObjectForKey:GameGuildCityControlDic];
        _leaderId = [aDecoder decodeObjectForKey:GameGuildLeaderId];
        _teamList = [aDecoder decodeObjectForKey:GameGuildTeamList];
        _cityKnowledgeSet = [aDecoder decodeObjectForKey:GameGuildCityKnowledgeSet];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_money forKey:GameGuildMoney];
    [aCoder encodeObject:_guildId forKey:GameGuildId];
    [aCoder encodeObject:_guildName forKey:GameGuildName];
    [aCoder encodeObject:_cityControlDic forKey:GameGuildCityControlDic];
    [aCoder encodeObject:_leaderId forKey:GameGuildLeaderId];
    [aCoder encodeObject:_teamList forKey:GameGuildTeamList];
    [aCoder encodeObject:_cityKnowledgeSet forKey:GameGuildCityKnowledgeSet];
}

-(void)spendMoney:(NSInteger)value
{
    NSInteger money = self.money - value;
    if (money < 0) {
        money = 0;
    }
    self.money = money;
}

-(void)buyItem:(GameItemData *)gameItemData withMoney:(int)money
{
    [self spendMoney:money];
    [gameItemData boughtByGuildNo:_guildId];
}

-(void)sellItem:(GameItemData *)gameItemData withMoney:(int)money toCityId:(NSString *)cityId
{
    self.money += money;
    [gameItemData sellToCityNo:cityId];
}

@end
