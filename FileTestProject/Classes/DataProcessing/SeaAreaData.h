#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface SeaAreaData : NSObject

@property (nonatomic, readonly) NSString *areaId;
@property (nonatomic, readonly) NSString *left;
@property (nonatomic, readonly) NSString *right;
@property (nonatomic, readonly) NSString *up;
@property (nonatomic, readonly) NSString *down;
@property (nonatomic, readonly) double scale;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface SeaAreaDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(SeaAreaData *)getSeaAreaById:(NSString *)areaId;

-(NSDictionary *)getDictionary;

@end