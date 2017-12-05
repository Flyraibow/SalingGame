/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface GuildData : NSObject

@property (nonatomic,readonly) NSString *guildId;

@property (nonatomic,readonly) NSString *cityList;

@property (nonatomic,readonly) NSString *occupationList;

@property (nonatomic,readonly) NSString *teamList;

@property (nonatomic,readonly) long money;

@property (nonatomic,readonly) NSString *leaderId;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface GuildDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(GuildData *)getGuildById:(NSString *)guildId;

@end

