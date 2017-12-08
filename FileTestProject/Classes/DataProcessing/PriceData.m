/* This file is generated, do not modify it !*/
#import "PriceData.h"
@implementation PriceData
{
	NSMutableDictionary *_dictionary;
}
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_dictionary = [NSMutableDictionary new];
		NSInteger colCount = [buffer readLong];
		NSMutableArray *colValues = [NSMutableArray new];
		for (int i = 0; i < colCount; ++i) {
			[colValues addObject:[buffer readString]];
		}
		NSInteger rowCount = [buffer readLong];
		NSMutableArray *rowValues = [NSMutableArray new];
		for (int i = 0; i < rowCount; ++i) {
			[rowValues addObject:[buffer readString]];
		}
		for (int i = 0; i < rowCount; ++i) {
			NSMutableDictionary *dict = [NSMutableDictionary new];
			for (int j = 0; j < colCount; ++j) {
				NSString *value = [buffer readString];
				dict[colValues[j]] = value;
			}
			_dictionary[rowValues[i]] = dict;
		}
	}
	return self;
}
-(int )getPriceByCultureId:(NSString *)cultureId goodsId:(NSString *)goodsId
{
	NSString *value = _dictionary[goodsId][cultureId];
	int val = [value intValue];
	return val;
}

@end

