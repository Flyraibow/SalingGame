/* This file is generated, do not modify it !*/
#import "GuildData.h"
@implementation GuildData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_guildId = [buffer readString];
		_cityList = [buffer readString];
		_occupationList = [buffer readString];
		_teamList = [buffer readString];
		_money = [buffer readLong];
		_leaderId = [buffer readString];
	}
	return self;
}

@end

@implementation GuildDic
{
	NSMutableDictionary *_data;
}
-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		int amount = [buffer readInt];
		_data = [NSMutableDictionary new];
		for (int i = 0; i < amount; ++i) {
			GuildData *data = [[GuildData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.guildId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(GuildData *)getGuildById:(NSString *)guildId
{
	return [_data objectForKey:guildId];
}

@end

