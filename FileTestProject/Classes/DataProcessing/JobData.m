/* This file is generated, do not modify it !*/
#import "JobData.h"
@implementation JobData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_jobId = [buffer readString];
		_conditions = [buffer readString];
	}
	return self;
}
-(NSString *)jobLabel
{
	return getJobLabel(_jobId);
}

@end

@implementation JobDic
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
			JobData *data = [[JobData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.jobId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(JobData *)getJobById:(NSString *)jobId
{
	return [_data objectForKey:jobId];
}

@end

