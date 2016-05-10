#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ItemData : NSObject

@property (nonatomic, readonly) NSString *itemId;
@property (nonatomic, readonly) NSString *iconId;
@property (nonatomic, readonly) int category;
@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) int value;
@property (nonatomic, readonly) int job;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) NSString *ownerCityId;
@property (nonatomic, readonly) NSString *ownerGuildId;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ItemDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(ItemData *)getItemById:(NSString *)itemId;

-(NSDictionary *)getDictionary;

@end