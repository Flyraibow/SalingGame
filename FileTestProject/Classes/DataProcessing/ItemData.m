#import "ItemData.h"
@implementation ItemDic
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
			ItemData *data = [[ItemData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.itemId];
		}
	}
	return self;
}

-(ItemData *)getItemById:(NSString *)itemId
{
	return [_data objectForKey:itemId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation ItemData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_itemId = [buffer readString];
		_iconId = [buffer readString];
		_category = [buffer readInt];
		_type = [buffer readInt];
		_value = [buffer readInt];
		_job = [buffer readInt];
		_price = [buffer readInt];
		_ownerCityId = [buffer readString];
		_ownerGuildId = [buffer readString];
	}
	return self;
}

@end