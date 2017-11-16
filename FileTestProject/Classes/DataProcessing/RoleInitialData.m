/* This file is generated, do not modify it !*/
#import "RoleInitialData.h"
@implementation RoleInitialData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_roldId = [buffer readString];
		_rolePhotoId = [buffer readInt];
		_guildId = [buffer readString];
		_dateBirthMonth = [buffer readInt];
		_dataBirthDay = [buffer readInt];
		_startYear = [buffer readInt];
		_startMonth = [buffer readInt];
		_startDay = [buffer readInt];
		_gender = [buffer readInt];
		_money = [buffer readInt];
		_startCityId = [buffer readString];
		_startStoryId = [buffer readString];
	}
	return self;
}

@end

@implementation RoleInitialDic
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
			RoleInitialData *data = [[RoleInitialData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.roldId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(RoleInitialData *)getRoleInitialById:(NSString *)roldId
{
	return [_data objectForKey:roldId];
}

@end

