/* This file is generated, do not modify it !*/
#import "ActionData.h"
@implementation ActionData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_actionId = [buffer readString];
		_typeId = [buffer readInt];
		_indexList = [buffer readString];
	}
	return self;
}

@end

@implementation ActionDic
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
			ActionData *data = [[ActionData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.actionId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(ActionData *)getActionById:(NSString *)actionId
{
	return [_data objectForKey:actionId];
}

@end

