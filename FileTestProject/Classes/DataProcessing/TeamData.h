#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface TeamData : NSObject

@property (nonatomic, readonly) NSString *teamId;
@property (nonatomic, readonly) NSString *leaderId;
@property (nonatomic, readonly) NSString *shiplist;
@property (nonatomic, readonly) NSString *startCity;
@property (nonatomic, readonly) NSInteger money;
@property (nonatomic, readonly) NSString *npcList;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface TeamDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(TeamData *)getTeamById:(NSString *)teamId;

-(NSDictionary *)getDictionary;

@end