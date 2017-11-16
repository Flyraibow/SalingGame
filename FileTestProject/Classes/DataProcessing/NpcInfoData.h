/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface NpcInfoData : NSObject

@property (nonatomic,readonly) NSString *npcId;

@property (nonatomic,readonly) int birthMonth;

@property (nonatomic,readonly) int birthDay;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface NpcInfoDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(NpcInfoData *)getNpcInfoById:(NSString *)npcId;

@end

