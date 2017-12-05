/* This file is generated, do not modify it !*/
#import "CityData.h"
@implementation CityData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_cityId = [buffer readString];
		_cultureId = [buffer readString];
		_cityType = [buffer readInt];
		_longitude = [buffer readDouble];
		_latitude = [buffer readDouble];
		_commerce = [buffer readInt];
		_milltary = [buffer readInt];
		_goods = [buffer readString];
		_buildings = [buffer readString];
		_ships = [buffer readString];
		_seaAreaId = [buffer readString];
		_cityScale = [buffer readInt];
		_unlockGoodsByItem = [buffer readString];
		_unlockShipsByCommerce = [buffer readString];
	}
	return self;
}
-(NSString *)cityLabel
{
	return getCityLabel(_cityId);
}

@end

@implementation CityDic
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
			CityData *data = [[CityData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.cityId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(CityData *)getCityById:(NSString *)cityId
{
	return [_data objectForKey:cityId];
}

@end

