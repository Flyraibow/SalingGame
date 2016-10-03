#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ShipData : NSObject

@property (nonatomic, readonly) NSString *shipId;
@property (nonatomic, readonly) NSString *style;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ShipDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ShipData *)getShipById:(NSString *)shipId;

-(NSDictionary *)getDictionary;

@end