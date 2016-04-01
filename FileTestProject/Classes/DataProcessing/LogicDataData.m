#import "LogicDataData.h"
@implementation LogicDataDic
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
			LogicDataData *data = [[LogicDataData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.dataName];
		}
	}
	return self;
}

-(LogicDataData *)getLogicDataById:(NSString *)dataName
{
	return [_data objectForKey:dataName];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation LogicDataData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_dataName = [buffer readString];
	}
	return self;
}

@end