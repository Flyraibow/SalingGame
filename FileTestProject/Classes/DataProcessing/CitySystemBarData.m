/* This file is generated, do not modify it !*/
#import "CitySystemBarData.h"
@implementation CitySystemBarData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_bottomBarId = [buffer readString];
		_eventAction = [buffer readString];
	}
	return self;
}
-(NSString *)buttonLabel
{
	NSString *string = [NSString stringWithFormat:@"building_name_%@",_bottomBarId];
	return NSLocalizedString(string, nil);
}

@end

@implementation CitySystemBarDic
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
			CitySystemBarData *data = [[CitySystemBarData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.bottomBarId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(CitySystemBarData *)getCitySystemBarById:(NSString *)bottomBarId
{
	return [_data objectForKey:bottomBarId];
}

@end

