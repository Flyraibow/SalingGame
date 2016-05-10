#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CityData : NSObject

@property (nonatomic, readonly) NSString *cityId;
@property (nonatomic, readonly) int cityBackground;
@property (nonatomic, readonly) int musicId;
@property (nonatomic, readonly) int cityType;
@property (nonatomic, readonly) int country;
@property (nonatomic, readonly) int cityStyle;
@property (nonatomic, readonly) int commerce;
@property (nonatomic, readonly) int milltary;
@property (nonatomic, readonly) NSString *goods;
@property (nonatomic, readonly) NSString *unlockGoodsByCommerce;
@property (nonatomic, readonly) NSString *goodsBoost;
@property (nonatomic, readonly) NSString *buildings;
@property (nonatomic, readonly) NSString *ships;
@property (nonatomic, readonly) int seaArea;
@property (nonatomic, readonly) int cityScale;
@property (nonatomic, readonly) int cityPosX;
@property (nonatomic, readonly) int cityPosY;
@property (nonatomic, readonly) NSString *unlockGoodsByItem;
@property (nonatomic, readonly) NSString *unlockShipsByCommerce;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface CityDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(CityData *)getCityById:(NSString *)cityId;

-(NSDictionary *)getDictionary;

@end