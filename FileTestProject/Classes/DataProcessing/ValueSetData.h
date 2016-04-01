#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface ValueSetData : NSObject

@property (nonatomic, readonly) NSString *settingId;
@property (nonatomic, readonly) int command;
@property (nonatomic, readonly) int hint;
@property (nonatomic, readonly) NSString *parameter1;
@property (nonatomic, readonly) NSString *parameter2;
@property (nonatomic, readonly) NSString *parameter3;
@property (nonatomic, readonly) NSString *parameter4;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface ValueSetDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSMutableArray *)getValueSetGroupByGroupId:(NSString *)groupIdName;

@end