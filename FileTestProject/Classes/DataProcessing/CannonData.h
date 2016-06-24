#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CannonData : NSObject

@property (nonatomic, readonly) NSString *cannonId;
@property (nonatomic, readonly) int range;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) int milltaryValue;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface CannonDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(CannonData *)getCannonById:(NSString *)cannonId;

-(NSDictionary *)getDictionary;

@end