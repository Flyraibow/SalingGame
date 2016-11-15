//
//  GuildData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuildData.h"
#import "GameItemData.h"

@interface GameGuildData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *guildId;
@property (nonatomic, readonly) NSString *guildName;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic) NSInteger money;
@property (nonatomic, readonly) NSMutableDictionary *cityControlDic;
@property (nonatomic, readonly) NSMutableSet *cityKnowledgeSet;
@property (nonatomic, readonly) NSMutableArray *teamList;

-(instancetype)initWithGameGuildData:(GameGuildData *)guildData;
-(instancetype)initWithGuildData:(GuildData *)guildData;
-(void)spendMoney:(NSInteger)value;

@end
