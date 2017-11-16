/* This file is generated, do not modify it !*/
#import "ConditionData.h"
@implementation ConditionData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_conditionId = [buffer readString];
		_type = [buffer readString];
		_subtype = [buffer readString];
		_compareType = [buffer readString];
		_type2 = [buffer readString];
		_subType2 = [buffer readString];
	}
	return self;
}

@end

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
-(NSDictionary *)getDictionary
{
	return _data;
}
-(ConditionData *)getConditionById:(NSString *)conditionId
{
	return [_data objectForKey:conditionId];
}

@end

