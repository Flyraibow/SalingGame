//
//  ByteBuffer.m
//  FileTestProject
//
//  Created by LIU YUJIE on 1/27/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ByteBuffer.h"

@implementation ByteBuffer

-(instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableData new];
        _pos = 0;
    }
    return self;
}

-(instancetype)initWithData:(NSData *)data
{
    self = [self init];
    if (self) {
        _data = [NSMutableData dataWithData:data];
    }
    return self;
}

-(void)writeInt:(int)value
{
    [_data appendBytes:&value length:4];
}

-(void)writeLong:(NSUInteger)value
{
    [_data appendBytes:&value length:8];
}

-(void)writeDouble:(double)value
{
    [_data appendBytes:&value length:8];
}

-(void)writeString:(NSString *)value
{
    NSUInteger length = value.length;
    [_data appendBytes:&length length:8];
    NSData *newData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [_data appendData:newData];
}

-(int)readInt
{
    int value = 0;
    [_data getBytes:&value range:NSMakeRange(_pos, 4)];
    _pos += 4;
    return value;
}

-(NSUInteger)readLong
{
    NSUInteger value = 0;
    [_data getBytes:&value range:NSMakeRange(_pos, 8)];
    _pos += 8;
    return value;
}

-(double)readDouble
{
    double value = 0;
    [_data getBytes:&value range:NSMakeRange(_pos, 8)];
    _pos += 8;
    return value;
}

-(NSString *)readString
{
    NSInteger len = 0;
    [_data getBytes:&len range:NSMakeRange(_pos, 8)];
    _pos += 8;
    NSData *data = [_data subdataWithRange:NSMakeRange(_pos, len)];
    _pos += len;
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return value;
}

-(NSMutableDictionary *)readMatrix
{
    NSUInteger len = [self readLong];
    NSMutableArray *array = [NSMutableArray new];
    for (NSUInteger i = 0; i < len; ++i) {
        [array addObject:[self readString]];
    }
    NSUInteger len2 = [self readLong];
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (NSUInteger i = 0; i < len2; ++i) {
        NSString *key = [self readString];
        NSMutableDictionary *dict = [NSMutableDictionary new];
        for (NSUInteger j = 0; j < len; ++j) {
            NSString *value = [self readString];
            [dict setObject:value  forKey:array[j]];
        }
        [dictionary setObject:dict forKey:key];
    }
    return dictionary;
}

-(NSSet *)readSet
{
  NSInteger len = [self readLong];
  NSMutableSet *set = [NSMutableSet new];
  for (NSUInteger i = 0; i < len; ++i) {
    [set addObject:[self readString]];
  }
  return set;
}

@end
