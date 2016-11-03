#import "CityBuildingData.h"
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

-(CityBuildingData *)getCityBuildingById:(NSString *)buildingId
{
	return [_data objectForKey:buildingId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation CityBuildingData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_buildingId = [buffer readString];
		_position = [buffer readInt];
		_npcNameId = [buffer readInt];
		_eventAction = [buffer readString];
	}
	return self;
}

@end