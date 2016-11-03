#import "ConditionData.h"
@implementation ConditionDic
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
			ConditionData *data = [[ConditionData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.conditionId];
		}
	}
	return self;
}

-(ConditionData *)getConditionById:(NSString *)conditionId
{
	return [_data objectForKey:conditionId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation ConditionData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_conditionId = [buffer readString];
		_type = [buffer readString];
		_compareType = [buffer readString];
		_parameter = [buffer readString];
	}
	return self;
}

@end