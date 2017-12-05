/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface TeamData : NSObject

@property (nonatomic,readonly) NSString *teamId;

@property (nonatomic,readonly) NSString *leaderId;

@property (nonatomic,readonly) NSString *shiplist;

@property (nonatomic,readonly) NSString *startCity;

@property (nonatomic,readonly) long money;

@property (nonatomic,readonly) NSString *npcList;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface TeamDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(TeamData *)getTeamById:(NSString *)teamId;

@end

