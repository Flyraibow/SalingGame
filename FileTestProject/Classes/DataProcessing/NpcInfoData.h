/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface NpcInfoData : NSObject

@property (nonatomic,readonly) NSString *npcId;

@property (nonatomic,readonly) NSString *portrait;

@property (nonatomic,readonly) NSString *potraitId;

@property (nonatomic,readonly) int portraitPosX;

@property (nonatomic,readonly) int portraitPosY;

@property (nonatomic,readonly) int gender;

@property (nonatomic,readonly) NSString *character;

@property (nonatomic,readonly) int zodiac;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface NpcInfoDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(NpcInfoData *)getNpcInfoById:(NSString *)npcId;

@end

