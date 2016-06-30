#import "ShipData.h"
@implementation ShipDic
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
			ShipData *data = [[ShipData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.shipId];
		}
	}
	return self;
}

-(ShipData *)getShipById:(NSString *)shipId
{
	return [_data objectForKey:shipId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation ShipData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_shipId = [buffer readString];
		_icon = [buffer readString];
		_style = [buffer readInt];
		_duration = [buffer readInt];
		_agile = [buffer readInt];
		_price = [buffer readInt];
		_minSailorNum = [buffer readInt];
		_maxSailorNum = [buffer readInt];
		_speed = [buffer readInt];
		_cannonId = [buffer readInt];
	}
	return self;
}

@end