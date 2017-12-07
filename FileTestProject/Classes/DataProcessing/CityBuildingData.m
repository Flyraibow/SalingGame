/* This file is generated, do not modify it !*/
#import "CityBuildingData.h"
@implementation CityBuildingData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_buildingId = [buffer readString];
		_position = [buffer readInt];
		_eventAction = [buffer readString];
		_buildingImage = [buffer readString];
	}
	return self;
}

@end

@implementation CityBuildingDic
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
			CityBuildingData *data = [[CityBuildingData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.buildingId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(CityBuildingData *)getCityBuildingById:(NSString *)buildingId
{
	return [_data objectForKey:buildingId];
}

@end

