/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

static NSString * getCityLabel(NSString *cityId)
{
	NSString *string = [NSString stringWithFormat:@"city_name_%@", cityId];
	return NSLocalizedString(string, nil);
}

@interface CityData : NSObject

@property (nonatomic,readonly) NSString *cityId;

@property (nonatomic,readonly) NSString *seaAreaId;

@property (nonatomic,readonly) NSString *cultureId;

@property (nonatomic,readonly) int cityType;

@property (nonatomic,readonly) double longitude;

@property (nonatomic,readonly) double latitude;

@property (nonatomic,readonly) int commerce;

@property (nonatomic,readonly) int milltary;

@property (nonatomic,readonly) NSString *goods;

@property (nonatomic,readonly) NSString *buildings;

@property (nonatomic,readonly) NSString *ships;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)cityLabel;

@end

@interface CityDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(CityData *)getCityById:(NSString *)cityId;

@end

