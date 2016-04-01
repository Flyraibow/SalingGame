//
//  GameRouteData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/24/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouteData.h"

typedef enum : NSUInteger {
    RouteTypePoints,
    RouteTypeSeaAreaChange
} RouteType;

@interface RoutePoint : NSObject

@property (nonatomic, assign) RouteType type;
@property (nonatomic, assign) CGPoint point; // if type is area change, then point is two area

-(instancetype)initWithPoint:(CGPoint)point type:(RouteType)type;
-(instancetype)initWithPointStr:(NSString*)pointStr;

@end

@interface GameRouteData : NSObject

+(void)initWithRouteDic:(RouteDic *)routeDic;

+(NSArray *)searchRoutes:(NSString *)city1 city2:(NSString *)city2;

+(NSDictionary *)sharedRouteDictionary;

@end
