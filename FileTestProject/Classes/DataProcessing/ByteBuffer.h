//
//  ByteBuffer.h
//  FileTestProject
//
//  Created by LIU YUJIE on 1/27/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByteBuffer : NSObject
{
    NSMutableData *_data;
    NSUInteger _pos;
}

-(instancetype)initWithData:(NSData *)data;

-(void)writeInt:(int)value;
-(void)writeLong:(NSUInteger)value;
-(void)writeDouble:(double)value;
-(void)writeString:(NSString *)value;

-(int)readInt;
-(NSUInteger)readLong;
-(double)readDouble;
-(NSString *)readString;
-(NSMutableDictionary *)readMatrix;
-(NSSet *)readSet;

@end
