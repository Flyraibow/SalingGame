/* This file is generated, do not modify it !*/
#import "TaskData.h"
@implementation TaskData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_taskStyleId = [buffer readString];
		_taskDescriptionId = [buffer readInt];
		_taskTitleId = [buffer readInt];
		_condition = [buffer readString];
		_targetItem = [buffer readString];
		_startCity = [buffer readInt];
		_destCity = [buffer readInt];
		_destBuilding = [buffer readInt];
		_priority = [buffer readInt];
	}
	return self;
}

@end

@implementation TaskDic
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
			TaskData *data = [[TaskData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.taskStyleId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(TaskData *)getTaskById:(NSString *)taskStyleId
{
	return [_data objectForKey:taskStyleId];
}

@end

