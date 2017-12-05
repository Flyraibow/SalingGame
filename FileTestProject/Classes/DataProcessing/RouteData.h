/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface RouteData : NSObject

@property (nonatomic,readonly) NSString *routeId;

@property (nonatomic,readonly) NSString *cityId1;

@property (nonatomic,readonly) NSString *cityId2;

@property (nonatomic,readonly) NSString *routes;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface RouteDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(RouteData *)getRouteById:(NSString *)routeId;

@end

