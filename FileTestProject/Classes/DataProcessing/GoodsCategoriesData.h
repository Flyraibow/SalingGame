#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface GoodsCategoriesData : NSObject

@property (nonatomic, readonly) NSString *categoryId;
@property (nonatomic, readonly) int updateType;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface GoodsCategoriesDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(GoodsCategoriesData *)getGoodsCategoriesById:(NSString *)categoryId;

-(NSDictionary *)getDictionary;

@end