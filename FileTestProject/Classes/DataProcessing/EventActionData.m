/* This file is generated, do not modify it !*/
#import "EventActionData.h"
@implementation EventActionData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_eventId = [buffer readString];
		_eventType = [buffer readString];
		_parameter = [buffer readString];
	}
	return self;
}

@end

@implementation EventActionDic
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
			EventActionData *data = [[EventActionData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.eventId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(EventActionData *)getEventActionById:(NSString *)eventId
{
	return [_data objectForKey:eventId];
}

@end

