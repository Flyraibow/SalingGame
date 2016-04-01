#import "TeamData.h"
@implementation TeamDic
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
			TeamData *data = [[TeamData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.teamId];
		}
	}
	return self;
}

-(TeamData *)getTeamById:(NSString *)teamId
{
	return [_data objectForKey:teamId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation TeamData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_teamId = [buffer readString];
		_leaderId = [buffer readString];
		_shiplist = [buffer readString];
		_startCity = [buffer readString];
		_money = [buffer readLong];
		_npcList = [buffer readString];
	}
	return self;
}

@end