/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface GoodsData : NSObject

@property (nonatomic,readonly) NSString *goodsId;

@property (nonatomic,readonly) int type;

@property (nonatomic,readonly) NSString *iconId;

@property (nonatomic,readonly) int maxNum;

@property (nonatomic,readonly) int needCommerce;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface GoodsDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(GoodsData *)getGoodsById:(NSString *)goodsId;

@end

