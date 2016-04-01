#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface GuildData : NSObject

@property (nonatomic, readonly) NSString *guildId;
@property (nonatomic, readonly) NSString *cityList;
@property (nonatomic, readonly) NSString *occupationList;
@property (nonatomic, readonly) NSString *teamList;
@property (nonatomic, readonly) NSInteger money;
@property (nonatomic, readonly) NSString *leaderId;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface GuildDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(GuildData *)getGuildById:(NSString *)guildId;

-(NSDictionary *)getDictionary;

@end