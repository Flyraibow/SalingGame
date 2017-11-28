/* This file is generated, do not modify it !*/
#import "CultureData.h"
@implementation CultureData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_cutureId = [buffer readString];
		_music = [buffer readString];
		_portrait = [buffer readInt];
	}
	return self;
}
-(NSString *)cultureLabel
{
	NSString *string = [NSString stringWithFormat:@"culture_name_%@",_cutureId];
	return NSLocalizedString(string, nil);
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

