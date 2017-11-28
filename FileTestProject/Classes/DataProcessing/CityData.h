/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CityData : NSObject

@property (nonatomic,readonly) NSString *cityId;

@property (nonatomic,readonly) NSString *cultureId;

@property (nonatomic,readonly) int cityType;

@property (nonatomic,readonly) double longitude;

@property (nonatomic,readonly) double latitude;

@property (nonatomic,readonly) int commerce;

@property (nonatomic,readonly) int milltary;

@property (nonatomic,readonly) NSString *goods;

@property (nonatomic,readonly) NSString *buildings;

@property (nonatomic,readonly) NSString *ships;

@property (nonatomic,readonly) NSString *seaAreaId;

@property (nonatomic,readonly) int cityScale;

@property (nonatomic,readonly) NSString *unlockGoodsByItem;

@property (nonatomic,readonly) NSString *unlockShipsByCommerce;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface CityDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(CityData *)getCityById:(NSString *)cityId;

@end

