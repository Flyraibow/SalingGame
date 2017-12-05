/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface CityBuildingData : NSObject

@property (nonatomic,readonly) NSString *buildingId;

@property (nonatomic,readonly) int position;

@property (nonatomic,readonly) NSString *eventAction;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface CityBuildingDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(CityBuildingData *)getCityBuildingById:(NSString *)buildingId;

@end

