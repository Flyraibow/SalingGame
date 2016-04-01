#import "GoodsData.h"
@implementation GoodsDic
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
			GoodsData *data = [[GoodsData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.goodsId];
		}
	}
	return self;
}

-(GoodsData *)getGoodsById:(NSString *)goodsId
{
	return [_data objectForKey:goodsId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation GoodsData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_goodsId = [buffer readString];
		_type = [buffer readInt];
		_iconId = [buffer readString];
		_maxNum = [buffer readInt];
		_needCommerce = [buffer readInt];
	}
	return self;
}

@end