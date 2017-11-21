/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface SelectListData : NSObject

@property (nonatomic,readonly) NSString *selectId;

@property (nonatomic,readonly) NSString *conditionList;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface SelectListDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(SelectListData *)getSelectListById:(NSString *)selectId;

@end

