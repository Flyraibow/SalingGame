//
//  GuildData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseData.h"

@class GuildData;
@class GameNPCData;
@interface GameGuildData : BaseData <NSCoding>

@property (nonatomic, readonly) NSString *guildId;
@property (nonatomic, readonly) NSString *guildName;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic) NSInteger money;
@property (nonatomic, readonly) NSMutableDictionary *cityControlDic;
@property (nonatomic, readonly) NSMutableSet *cityKnowledgeSet;
@property (nonatomic, readonly) NSMutableArray *teamList;

@property (nonatomic, readonly) NSInteger sellItemNumber;
@property (nonatomic, readonly) GameNPCData *leaderData;

-(instancetype)initWithGameGuildData:(GameGuildData *)guildData;
-(instancetype)initWithGuildData:(GuildData *)guildData;
-(void)spendMoney:(NSInteger)value;

@end
