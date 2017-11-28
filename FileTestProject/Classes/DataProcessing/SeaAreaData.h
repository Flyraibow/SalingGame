/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface SeaAreaData : NSObject

@property (nonatomic,readonly) NSString *areaId;

@property (nonatomic,readonly) NSString *left;

@property (nonatomic,readonly) NSString *rightUp;

@property (nonatomic,readonly) NSString *right;

@property (nonatomic,readonly) NSString *rightDown;

@property (nonatomic,readonly) NSString *up;

@property (nonatomic,readonly) NSString *down;

@property (nonatomic,readonly) double x1;

@property (nonatomic,readonly) double y1;

@property (nonatomic,readonly) double x2;

@property (nonatomic,readonly) double y2;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)areaLabel;

@end

@interface SeaAreaDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(SeaAreaData *)getSeaAreaById:(NSString *)areaId;

@end

