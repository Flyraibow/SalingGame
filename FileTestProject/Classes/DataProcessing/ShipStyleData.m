#import "ShipStyleData.h"
@implementation ShipStyleDic
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
			ShipStyleData *data = [[ShipStyleData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.shipStyleId];
		}
	}
	return self;
}

-(ShipStyleData *)getShipStyleById:(NSString *)shipStyleId
{
	return [_data objectForKey:shipStyleId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation ShipStyleData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_shipStyleId = [buffer readString];
		_deckShipIcon = [buffer readInt];
		_scale = [buffer readInt];
		_roomList = [buffer readString];
		_equipList = [buffer readString];
	}
	return self;
}

@end