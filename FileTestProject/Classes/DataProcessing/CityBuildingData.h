#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CityBuildingData : NSObject

@property (nonatomic, readonly) NSString *buildingId;
@property (nonatomic, readonly) int position;
@property (nonatomic, readonly) int npcNameId;
@property (nonatomic, readonly) NSString *eventAction;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface CityBuildingDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(CityBuildingData *)getCityBuildingById:(NSString *)buildingId;

-(NSDictionary *)getDictionary;

@end