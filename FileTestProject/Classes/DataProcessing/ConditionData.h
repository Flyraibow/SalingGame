#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ConditionData : NSObject

@property (nonatomic, readonly) NSString *conditionId;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *subtype;
@property (nonatomic, readonly) NSString *compareType;
@property (nonatomic, readonly) NSString *type2;
@property (nonatomic, readonly) NSString *subType2;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ConditionDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ConditionData *)getConditionById:(NSString *)conditionId;

-(NSDictionary *)getDictionary;

@end