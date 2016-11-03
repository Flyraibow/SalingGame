#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface SelectListData : NSObject

@property (nonatomic, readonly) NSString *selectId;
@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) NSString *conditionList;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface SelectListDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(SelectListData *)getSelectListById:(NSString *)selectId;

-(NSDictionary *)getDictionary;

@end