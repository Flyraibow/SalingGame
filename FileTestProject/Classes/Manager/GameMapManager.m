//
//  GameMapManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "GameMapManager.h"

static MapData *_sharedMap;

@implementation GameMapManager

+(MapData *)sharedMapData
{
  if (_sharedMap == nil) {
    NSString *mapPath = [[NSBundle mainBundle] pathForResource: @"map" ofType: @"dat"];
    NSData *mapData = [NSData dataWithContentsOfFile:mapPath];
    _sharedMap = [MapData mapWithData:mapData];
  }
  return _sharedMap;
}


@end
