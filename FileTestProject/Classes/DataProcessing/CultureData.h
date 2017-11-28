/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface CultureData : NSObject

@property (nonatomic,readonly) NSString *cutureId;

@property (nonatomic,readonly) NSString *music;

@property (nonatomic,readonly) int portrait;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)cultureLabel;

@end

@interface CultureDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(CultureData *)getCultureById:(NSString *)cutureId;

@end

