#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface EventActionData : NSObject

@property (nonatomic, readonly) NSString *eventId;
@property (nonatomic, readonly) NSString *eventType;
@property (nonatomic, readonly) NSString *parameter;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface EventActionDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(EventActionData *)getEventActionById:(NSString *)eventId;

-(NSDictionary *)getDictionary;

@end