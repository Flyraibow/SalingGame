#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ShipData : NSObject

@property (nonatomic, readonly) NSString *shipId;
@property (nonatomic, readonly) NSString *icon;
@property (nonatomic, readonly) int style;
@property (nonatomic, readonly) int duration;
@property (nonatomic, readonly) int agile;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) int minSailorNum;
@property (nonatomic, readonly) int maxSailorNum;
@property (nonatomic, readonly) int speed;
@property (nonatomic, readonly) int cannonId;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ShipDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ShipData *)getShipById:(NSString *)shipId;

-(NSDictionary *)getDictionary;

@end