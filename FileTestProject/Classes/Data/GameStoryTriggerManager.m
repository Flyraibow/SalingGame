//
//  GameStoryTriggerManager.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/28/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameStoryTriggerManager.h"
#import "DataManager.h"
#import "GameCityData.h"
#import "GameDataManager.h"
#import "MyGuild.h"
#import "GameNPCData.h"

@implementation GameStoryTriggerManager

+(NSString *)searchStory:(NSString *)cityId buildingId:(NSString *)buildingId
{
    int currentPriority = -1;
    NSString *currentStoryId = nil;
    NSDictionary *storyTriggerDic = [[[DataManager sharedDataManager] getStoryTriggerDic] getDictionary];
    MyGuild *myGuild = [GameDataManager sharedGameData].myGuild;
    NSSet *usedStorySet = myGuild.usedStorySet;
    for (NSString *storyId in storyTriggerDic) {
        // 主角符合
        StoryTriggerData *storyTriggerData = [storyTriggerDic objectForKey:storyId];
        if (![storyTriggerData.heroId isEqualToString:@"0"] && ![storyTriggerData.heroId isEqualToString:myGuild.leaderId]) {
            continue;
        }
        //是已经触发了任务
        if (!storyTriggerData.repeatable && [usedStorySet containsObject:storyId]) {
            continue;
        }
        // 角色是否在队伍里的判断
        if (![storyTriggerData.npcInTeam isEqualToString:@"0"]) {
            NSArray *npcList = [storyTriggerData.npcInTeam componentsSeparatedByString:@";"];
            BOOL flag = NO;
            for (int i = 0; i < npcList.count; ++i) {
                NSString *npcId = [npcList objectAtIndex:i];
                if (![myGuild.myTeam.npcList containsObject:[[GameDataManager sharedGameData].npcDic objectForKey:npcId]]) {
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                continue;
            }
        }
        // 角色不在队伍里的判断
        if (![storyTriggerData.npcNotInTeam isEqualToString:@"0"]) {
            NSArray *npcList = [storyTriggerData.npcInTeam componentsSeparatedByString:@";"];
            BOOL flag = NO;
            for (int i = 0; i < npcList.count; ++i) {
                NSString *npcId = [npcList objectAtIndex:i];
                if ([myGuild.myTeam.npcList containsObject:[[GameDataManager sharedGameData].npcDic objectForKey:npcId]]) {
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                continue;
            }
        }
        // 城市符合
        if (![storyTriggerData.cityId isEqualToString:@"0"]) {
            if ([storyTriggerData.cityId characterAtIndex:0] == '!') {
                //不是某个城市
                if ([[storyTriggerData.cityId componentsSeparatedByString:@";"] containsObject:cityId]) {
                    continue;
                }
            } else if ([[storyTriggerData.cityId componentsSeparatedByString:@";"] containsObject:cityId] == NO) {
                continue;
            }
        }
        //  建筑符合
        if (![storyTriggerData.buildingId isEqualToString:@"0"]) {
            if ([storyTriggerData.buildingId characterAtIndex:0] == '!') {
                //不是某个建筑
                if ([[storyTriggerData.buildingId componentsSeparatedByString:@";"] containsObject:buildingId]) {
                    continue;
                }
            } else if ([[storyTriggerData.buildingId componentsSeparatedByString:@";"] containsObject:buildingId] == NO) {
                continue;
            }
        }
        BOOL storyFlag = YES;
        if (![storyTriggerData.prefixStoryId isEqual:@"0"]) {
            NSArray *prefixStoryArray = [storyTriggerData.prefixStoryId componentsSeparatedByString:@";"];
            for (NSString *prefixStoryString in prefixStoryArray) {
                if (![usedStorySet containsObject:prefixStoryString]) {
                    storyFlag = NO;
                    break;
                }
            }
        }
        if (storyFlag) {
            // 前置剧情符合
            if (![storyTriggerData.forbiddenStoryId isEqual:@"0"]) {
                NSArray *forbiddenStoryArray = [storyTriggerData.forbiddenStoryId componentsSeparatedByString:@";"];
                for (NSString *forbiddenStoryId in forbiddenStoryArray) {
                    if ([usedStorySet containsObject:forbiddenStoryId]) {
                        storyFlag = NO;
                        break;
                    }
                }
            }
            if (storyFlag) {
                //禁止剧情符合
                if ([storyTriggerData.year isEqualToString:@"0"] || [[storyTriggerData.year componentsSeparatedByString:@";"] containsObject:[@([GameDataManager sharedGameData].year) stringValue]]) {
                    // 年份符合
                    if ([storyTriggerData.month isEqualToString:@"0"] || [[storyTriggerData.month componentsSeparatedByString:@";"] containsObject:[@([GameDataManager sharedGameData].month) stringValue]]) {
                        // 月份符合
                        if ([storyTriggerData.day isEqualToString:@"0"] || [[storyTriggerData.day componentsSeparatedByString:@";"] containsObject:[@([GameDataManager sharedGameData].day) stringValue]]) {
                            // 日子符合
                            GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityId];
                            if (cityData == nil || ((storyTriggerData.commerce <= cityData.commerceValue && storyTriggerData.military <= cityData.milltaryValue) && [[cityData.guildOccupation objectForKey:[GameDataManager sharedGameData].myGuild.guildId] intValue] >= storyTriggerData.cityPercentage)) {
                                // 投资份额和占有率符合
                                if ([GameDataManager sharedGameData].myGuild.money >= storyTriggerData.money) {
                                    // 金钱符合
                                    if (currentPriority < storyTriggerData.priority) {
                                        currentPriority = storyTriggerData.priority;
                                        currentStoryId = storyTriggerData.storyId;
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    return currentStoryId;
}

@end
