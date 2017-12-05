/* This file is generated, do not modify it !*/
#import "SeaAreaData.h"
@implementation SeaAreaData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_areaId = [buffer readString];
		_left = [buffer readString];
		_rightUp = [buffer readString];
		_right = [buffer readString];
		_rightDown = [buffer readString];
		_up = [buffer readString];
		_down = [buffer readString];
		_x1 = [buffer readDouble];
		_y1 = [buffer readDouble];
		_x2 = [buffer readDouble];
		_y2 = [buffer readDouble];
	}
	return self;
}
-(NSString *)areaLabel
{
	return getAreaLabel(_areaId);
}

@end

@implementation SeaAreaDic
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
			SeaAreaData *data = [[SeaAreaData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.areaId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(SeaAreaData *)getSeaAreaById:(NSString *)areaId
{
	return [_data objectForKey:areaId];
}

@end

