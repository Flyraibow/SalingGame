/* This file is generated, do not modify it !*/
#import "ItemData.h"
@implementation ItemData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
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
-(NSString *)itemDescription
{
	return getItemDescription(_itemId);
}

@end

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
-(NSDictionary *)getDictionary
{
	return _data;
}
-(ItemData *)getItemById:(NSString *)itemId
{
	return [_data objectForKey:itemId];
}

@end

