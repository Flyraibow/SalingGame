/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface PriceData : NSObject

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(int )getPriceByCultureId:(NSString *)cultureId goodsId:(NSString *)goodsId;

@end

