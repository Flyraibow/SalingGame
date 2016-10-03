#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ShipStyleData : NSObject

@property (nonatomic, readonly) NSString *shipStyleId;
@property (nonatomic, readonly) NSString *icon;
@property (nonatomic, readonly) int deckShipIcon;
@property (nonatomic, readonly) int scale;
@property (nonatomic, readonly) NSString *roomList;
@property (nonatomic, readonly) NSString *equipList;
@property (nonatomic, readonly) int duration;
@property (nonatomic, readonly) int agile;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) int minSailorNum;
@property (nonatomic, readonly) int maxSailorNum;
@property (nonatomic, readonly) int speed;
@property (nonatomic, readonly) int cannonId;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ShipStyleDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ShipStyleData *)getShipStyleById:(NSString *)shipStyleId;

-(NSDictionary *)getDictionary;

@end