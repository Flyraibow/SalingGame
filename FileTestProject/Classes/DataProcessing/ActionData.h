#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ActionData : NSObject

@property (nonatomic, readonly) NSString *actionId;
@property (nonatomic, readonly) int typeId;
@property (nonatomic, readonly) NSString *indexList;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ActionDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ActionData *)getActionById:(NSString *)actionId;

-(NSDictionary *)getDictionary;

@end