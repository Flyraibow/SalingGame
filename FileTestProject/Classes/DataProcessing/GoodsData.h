/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface GoodsData : NSObject

@property (nonatomic,readonly) NSString *goodsId;

@property (nonatomic,readonly) int type;

@property (nonatomic,readonly) NSString *iconId;

@property (nonatomic,readonly) int maxPrice;

@property (nonatomic,readonly) int levelUpExp;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface GoodsDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(GoodsData *)getGoodsById:(NSString *)goodsId;

@end

