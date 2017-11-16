/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface SkillData : NSObject

@property (nonatomic,readonly) NSString *skillId;

@property (nonatomic,readonly) NSString *exp;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface SkillDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(SkillData *)getSkillById:(NSString *)skillId;

@end

