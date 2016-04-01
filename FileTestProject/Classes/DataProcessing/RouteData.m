#import "RouteData.h"
@implementation RouteDic
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
			RouteData *data = [[RouteData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.routeId];
		}
	}
	return self;
}

-(RouteData *)getRouteById:(NSString *)routeId
{
	return [_data objectForKey:routeId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation RouteData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_routeId = [buffer readString];
		_cityId1 = [buffer readString];
		_cityId2 = [buffer readString];
		_routes = [buffer readString];
	}
	return self;
}

@end