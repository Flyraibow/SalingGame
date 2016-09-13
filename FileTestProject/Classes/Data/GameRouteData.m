//
//  GameRouteData.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/24/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameRouteData.h"
#import "DataManager.h"

@implementation RoutePoint

-(NSString *)description
{
    return NSStringFromCGPoint(self.point);
}

-(instancetype)initWithPoint:(CGPoint)point type:(RouteType)type
{
    if (self = [super init]) {
        _point = point;
        _type = type;
    }
    return self;
}

-(instancetype)initWithPointStr:(NSString*)pointStr
{
    if (self = [super init]) {
        if ([pointStr containsString:@"_"]) {
            NSArray *pointArr = [pointStr componentsSeparatedByString:@"_"];
            _point = CGPointMake([[pointArr objectAtIndex:0] intValue], [[pointArr objectAtIndex:1] intValue]);
            _type = RouteTypePoints;
        } else {
            
            NSArray *pointArr = [pointStr componentsSeparatedByString:@"-"];
            _point = CGPointMake([[pointArr objectAtIndex:0] intValue], [[pointArr objectAtIndex:1] intValue]);
            _type = RouteTypeSeaAreaChange;
        }
    }
    return self;
}

@end

static NSMutableDictionary *_sharedRouteData;

@implementation GameRouteData
{
}

+(void)initWithRouteDic:(RouteDic *)routeDic
{
    _sharedRouteData = [NSMutableDictionary new];
    for (NSString *routeId in routeDic.getDictionary) {
        RouteData *routeData = [routeDic.getDictionary objectForKey:routeId];
        NSString *city1 = routeData.cityId1;
        NSString *city2 = routeData.cityId2;
        CityData *cityData1 = [[DataManager sharedDataManager].getCityDic getCityById:city1];
        CityData *cityData2 = [[DataManager sharedDataManager].getCityDic getCityById:city2];
        NSMutableDictionary *routesDict1 = [_sharedRouteData objectForKey:city1];
        NSMutableArray *routesList1 = [NSMutableArray new];
        if (routesDict1 == nil) {
            routesDict1 = [NSMutableDictionary new];
            [_sharedRouteData setObject:routesDict1 forKey:city1];
        }
        [routesDict1 setObject:routesList1 forKey:city2];
        
        NSMutableDictionary *routesDict2 = [_sharedRouteData objectForKey:city2];
        NSMutableArray *routesList2 = [NSMutableArray new];
        if (routesDict2 == nil) {
            routesDict2 = [NSMutableDictionary new];
            [_sharedRouteData setObject:routesDict2 forKey:city2];
        }
        [routesDict2 setObject:routesList2 forKey:city1];
        
        RoutePoint *cityPoint1 = [[RoutePoint alloc] initWithPoint:CGPointMake(cityData1.cityPosX, cityData1.cityPosY) type:RouteTypePoints];
        RoutePoint *cityPoint2 = [[RoutePoint alloc] initWithPoint:CGPointMake(cityData2.cityPosX, cityData2.cityPosY) type:RouteTypePoints];
        [routesList1 addObject:cityPoint1];
        [routesList2 addObject:cityPoint2];
        
        NSString *routes = routeData.routes;
        NSArray *routeList = [routes componentsSeparatedByString:@";"];
        for (int i = 0; i < routeList.count; ++i) {
            NSString *pointStr = [routeList objectAtIndex:i];
            if (pointStr.length > 0) {
                RoutePoint *routePoint = [[RoutePoint alloc] initWithPointStr:pointStr];
                [routesList1 addObject:routePoint];
                if (routePoint.type == RouteTypeSeaAreaChange) {
                    RoutePoint *routePoint1 = [[RoutePoint alloc] initWithPoint:CGPointMake(routePoint.point.y, routePoint.point.x) type:RouteTypeSeaAreaChange];
                    [routesList2 insertObject:routePoint1 atIndex:1];
                } else {
                    [routesList2 insertObject:routePoint atIndex:1];
                }
            }
        }
        [routesList1 addObject:cityPoint2];
        [routesList2 addObject:cityPoint1];
    }
}

//use Dij to calculate
+(NSArray *)searchRoutes:(NSString *)city1 city2:(NSString *)city2
{
    if ([city1 isEqualToString:city2]) {
        return nil;
    }
    NSMutableDictionary *candidateDict = [NSMutableDictionary new];
    NSMutableDictionary *closedDict = [NSMutableDictionary new];
    [candidateDict setObject:@{@"distance":@(0) ,@"lastPoint":[NSNull null]} forKey:city1];
    while ([candidateDict count] > 0) {
        // remove the best one from candidate into close one
        double miniDistance = CGFLOAT_MAX;
        NSString *candidateCityNo = nil;
        for (NSString *cityNo in candidateDict) {
            double currentDistance = [[[candidateDict objectForKey:cityNo] objectForKey:@"distance"] doubleValue];
            if (currentDistance < miniDistance) {
                miniDistance = currentDistance;
                candidateCityNo = cityNo;
            }
        }
        [closedDict setObject:[candidateDict objectForKey:candidateCityNo] forKey:candidateCityNo];
        [candidateDict removeObjectForKey:candidateCityNo];
        if ([candidateCityNo isEqualToString:city2]) {
            break;
        }
        
        NSDictionary *toCityDict = [_sharedRouteData objectForKey:candidateCityNo];
        for (NSString *nextCity in toCityDict) {
            if ([closedDict objectForKey:nextCity] == nil) {
                NSArray *routeList = [toCityDict objectForKey:nextCity];
                double distance = miniDistance;
                for (int i = 0; i < routeList.count - 1; ++i) {
                    RoutePoint *routePoint1 = [routeList objectAtIndex:i];
                    RoutePoint *routePoint2 = [routeList objectAtIndex:i+1];
                    if (routePoint1.type == RouteTypePoints && routePoint2.type == RouteTypePoints) {
                        CGFloat diffX = routePoint1.point.x - routePoint2.point.x;
                        CGFloat diffY = routePoint1.point.y - routePoint2.point.y;
                        distance += sqrt(diffX * diffX + diffY * diffY);
                    }
                }
                if ([candidateDict objectForKey:nextCity] != nil) {
                    if ([[[candidateDict objectForKey:nextCity] objectForKey:@"distance"] doubleValue] > distance) {
                        [candidateDict setObject:@{@"distance":@(distance) ,@"lastPoint":candidateCityNo} forKey:nextCity];
                    }
                } else {
                    [candidateDict setObject:@{@"distance":@(distance) ,@"lastPoint":candidateCityNo} forKey:nextCity];
                }
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    NSString *currentCity = city2;
    while (![currentCity isEqual:[NSNull null]]) {
        [array addObject:currentCity];
        currentCity = [[closedDict objectForKey:currentCity] objectForKey:@"lastPoint"];
    }
    return array;
}

+(NSDictionary *)sharedRouteDictionary
{
    return _sharedRouteData;
}

@end
