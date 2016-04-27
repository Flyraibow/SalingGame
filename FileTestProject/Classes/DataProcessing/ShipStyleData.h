#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ShipStyleData : NSObject

@property (nonatomic, readonly) NSString *shipStyleId;
@property (nonatomic, readonly) int deckShipIcon;
@property (nonatomic, readonly) int scale;
@property (nonatomic, readonly) NSString *roomList;
@property (nonatomic, readonly) NSString *equipList;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ShipStyleDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ShipStyleData *)getShipStyleById:(NSString *)shipStyleId;

-(NSDictionary *)getDictionary;

@end