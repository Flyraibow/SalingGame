#import "CityData.h"
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

-(CityData *)getCityById:(NSString *)cityId
{
	return [_data objectForKey:cityId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation CityData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_cityId = [buffer readString];
		_cityBackground = [buffer readInt];
		_musicId = [buffer readInt];
		_cityType = [buffer readInt];
		_country = [buffer readInt];
		_cityStyle = [buffer readInt];
		_commerce = [buffer readInt];
		_milltary = [buffer readInt];
		_goods = [buffer readString];
		_unlockGoodsByCommerce = [buffer readString];
		_goodsBoost = [buffer readString];
		_buildings = [buffer readString];
		_ships = [buffer readString];
		_seaArea = [buffer readInt];
		_cityScale = [buffer readInt];
		_cityPosX = [buffer readInt];
		_cityPosY = [buffer readInt];
		_unlockGoodsByItem = [buffer readString];
		_unlockShipsByCommerce = [buffer readString];
	}
	return self;
}

@end