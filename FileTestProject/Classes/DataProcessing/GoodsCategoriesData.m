/* This file is generated, do not modify it !*/
#import "GoodsCategoriesData.h"
@implementation GoodsCategoriesData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_categoryId = [buffer readString];
		_updateType = [buffer readInt];
	}
	return self;
}

@end

@implementation GoodsCategoriesDic
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
			GoodsCategoriesData *data = [[GoodsCategoriesData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.categoryId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(GoodsCategoriesData *)getGoodsCategoriesById:(NSString *)categoryId
{
	return [_data objectForKey:categoryId];
}

@end

