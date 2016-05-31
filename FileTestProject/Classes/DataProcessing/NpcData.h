#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface NpcData : NSObject

@property (nonatomic, readonly) NSString *npcId;
@property (nonatomic, readonly) NSString *character;
@property (nonatomic, readonly) int gender;
@property (nonatomic, readonly) NSString *dialogPotraitId;
@property (nonatomic, readonly) NSString *potraitId;
@property (nonatomic, readonly) int portraitPosX;
@property (nonatomic, readonly) int portraitPosY;
@property (nonatomic, readonly) int level;
@property (nonatomic, readonly) int hp;
@property (nonatomic, readonly) NSString *equipWeapon;
@property (nonatomic, readonly) NSString *equipAmor;
@property (nonatomic, readonly) NSString *equipList;
@property (nonatomic, readonly) int strength;
@property (nonatomic, readonly) int intelligence;
@property (nonatomic, readonly) int agile;
@property (nonatomic, readonly) int charm;
@property (nonatomic, readonly) int eloquence;
@property (nonatomic, readonly) int luck;
@property (nonatomic, readonly) NSString *skillList;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface NpcDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NpcData *)getNpcById:(NSString *)npcId;

-(NSDictionary *)getDictionary;

@end