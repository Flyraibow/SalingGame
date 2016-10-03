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
		_style = [buffer readString];
	}
	return self;
}

@end