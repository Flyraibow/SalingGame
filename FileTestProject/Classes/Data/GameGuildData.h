//
//  GuildData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuildData.h"

@interface GameGuildData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *guildId;
@property (nonatomic, readonly) NSString *guildName;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic, readonly) NSInteger money;
@property (nonatomic, readonly) NSMutableDictionary *cityControlDic;
@property (nonatomic, readonly) NSMutableSet *cityKnowledgeSet;
@property (nonatomic, readonly) NSMutableArray *teamList;
@property (nonatomic, readonly) NSDictionary *itemDict; // there is no two

-(instancetype)initWithGameGuildData:(GameGuildData *)guildData;
-(instancetype)initWithGuildData:(GuildData *)guildData;
-(void)gainMoney:(NSInteger)value;
-(void)spendMoney:(NSInteger)value;
-(void)setMoney:(NSInteger)money;
-(void)addItem:(NSString *)itemId;
-(void)removeItem:(NSString *)itemId;

@end
