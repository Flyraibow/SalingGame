//
//  MapData.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "MapData.h"
#import "ByteBuffer.h"

@implementation MapData

+(MapData *)mapWithData:(NSData *)data
{
  return [[MapData alloc] initWithData:data];
}


-(instancetype)initWithData:(NSData *)data
{
  if ([self init]) {
    ByteBuffer *buffer = [[ByteBuffer alloc] initWithData:data];
    _width = [buffer readInt];
    _height = [buffer readInt];
    NSMutableArray *mapMatrix;
    for (int i = 0; i < _height; ++i) {
      NSMutableArray *mapRow;
      for (int j = 0; j < _width; ++j) {
        Byte bt = [buffer readByte];
        [mapRow addObject:@(bt)];
      }
      [mapMatrix addObject:mapRow];
    }
    _mapMatrix = [mapMatrix copy];
  }
  return self;
}

@end
