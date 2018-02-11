/* This file is generated, do not modify it !*/
#import "CultureData.h"
@implementation CultureData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_cutureId = [buffer readString];
		_music = [buffer readString];
		_PlazaStore = [buffer readString];
		_PlazaBuilding = [buffer readString];
		_portrait = [buffer readInt];
	}
	return self;
}
-(NSString *)cultureLabel
{
	return getCultureLabel(_cutureId);
}

@end

@implementation CultureDic
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
			CultureData *data = [[CultureData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.cutureId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(CultureData *)getCultureById:(NSString *)cutureId
{
	return [_data objectForKey:cutureId];
}

@end

