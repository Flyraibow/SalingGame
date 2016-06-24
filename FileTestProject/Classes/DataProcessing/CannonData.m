#import "CannonData.h"
@implementation CannonDic
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
			CannonData *data = [[CannonData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.cannonId];
		}
	}
	return self;
}

-(CannonData *)getCannonById:(NSString *)cannonId
{
	return [_data objectForKey:cannonId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation CannonData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_cannonId = [buffer readString];
		_range = [buffer readInt];
		_price = [buffer readInt];
		_milltaryValue = [buffer readInt];
	}
	return self;
}

@end