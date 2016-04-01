#import "SkillData.h"
@implementation SkillDic
{
	NSMutableDictionary *_data;
}

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		int amount = [buffer readInt];
		_data = [NSMutableDictionary new];
		for (int i = 0; i < amount; ++i) {
			SkillData *data = [[SkillData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.skillId];
		}
	}
	return self;
}

-(SkillData *)getSkillById:(NSString *)skillId
{
	return [_data objectForKey:skillId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation SkillData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_skillId = [buffer readString];
		_exp = [buffer readString];
	}
	return self;
}

@end