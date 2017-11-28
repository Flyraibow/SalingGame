/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface GoodsCategoriesData : NSObject

@property (nonatomic,readonly) NSString *categoryId;

@property (nonatomic,readonly) NSString *categoryUpdateId;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface GoodsCategoriesDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(GoodsCategoriesData *)getGoodsCategoriesById:(NSString *)categoryId;

@end

