/* This file is generated, do not modify it !*/
#import "CategoryUpdateData.h"
@implementation CategoryUpdateData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_categoryUpdateId = [buffer readString];
		_updateMonth = [buffer readSet];
	}
	return self;
}
-(NSString *)categoryUpdateLabel
{
	return getCategoryUpdateLabel(_categoryUpdateId);
}

@end

@implementation CategoryUpdateDic
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
			CategoryUpdateData *data = [[CategoryUpdateData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.categoryUpdateId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(CategoryUpdateData *)getCategoryUpdateById:(NSString *)categoryUpdateId
{
	return [_data objectForKey:categoryUpdateId];
}

@end

