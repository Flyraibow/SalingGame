/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface NpcData : NSObject

@property (nonatomic,readonly) NSString *npcId;

@property (nonatomic,readonly) int level;

@property (nonatomic,readonly) int hp;

@property (nonatomic,readonly) NSString *equipWeapon;

@property (nonatomic,readonly) NSString *equipAmor;

@property (nonatomic,readonly) NSString *equipList;

@property (nonatomic,readonly) int strength;

@property (nonatomic,readonly) int intelligence;

@property (nonatomic,readonly) int agile;

@property (nonatomic,readonly) int charm;

@property (nonatomic,readonly) int eloquence;

@property (nonatomic,readonly) int luck;

@property (nonatomic,readonly) NSString *skillList;

@property (nonatomic,readonly) NSString *jobLimited;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface NpcDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(NpcData *)getNpcById:(NSString *)npcId;

@end

