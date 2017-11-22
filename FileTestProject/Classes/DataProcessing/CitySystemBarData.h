/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CitySystemBarData : NSObject

@property (nonatomic,readonly) NSString *bottomBarId;

@property (nonatomic,readonly) NSString *eventAction;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)buttonLabel;

@end

@interface CitySystemBarDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(CitySystemBarData *)getCitySystemBarById:(NSString *)bottomBarId;

@end

