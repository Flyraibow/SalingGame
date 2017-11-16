/* this file is generated */
#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface LogicDataData : NSObject

@property (nonatomic, readonly) NSString *dataName;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface LogicDataDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(LogicDataData *)getLogicDataById:(NSString *)dataName;

-(NSDictionary *)getDictionary;

@end