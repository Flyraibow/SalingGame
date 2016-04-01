//
//  SailSceneDrawLayer.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/24/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SailSceneDrawLayer.h"
#import "GameRouteData.h"

@implementation SailSceneDrawLayer

-(void)drawCityRoutes:(NSSet *)citySets
{
    NSMutableSet *routesFlag = [NSMutableSet new];
    NSDictionary *routeData = [GameRouteData sharedRouteDictionary];
    for (NSString *cityNo in citySets) {
        NSDictionary *cityRouteDict = [routeData objectForKey:cityNo];
        if (cityRouteDict != nil) {
            for (NSString *toCityNo in cityRouteDict) {
                NSString *routeId = [NSString stringWithFormat:@"%@_%@",cityNo,toCityNo];
                if (![routesFlag containsObject:routeId]) {
                    [routesFlag addObject: routeId];
                    [routesFlag addObject:[NSString stringWithFormat:@"%@_%@",toCityNo,cityNo]];
                    NSArray *array = [cityRouteDict objectForKey:toCityNo];
                    for (int i = 0; i < array.count - 1; ++i) {
                        RoutePoint *point1 = [array objectAtIndex:i];
                        RoutePoint *point2 = [array objectAtIndex:i + 1];
                        if (point2.type == RouteTypePoints) {
                            [self drawSegmentFrom:point1.point to:point2.point radius:1 color:[CCColor greenColor]];
                        } else {
                            break;
                        }
                    }
                }
            }
                
        }
    }
}

@end
