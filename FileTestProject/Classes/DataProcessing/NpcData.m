#import "NpcData.h"
@implementation NpcDic
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
			NpcData *data = [[NpcData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.npcId];
		}
	}
	return self;
}

-(NpcData *)getNpcById:(NSString *)npcId
{
	return [_data objectForKey:npcId];
}

-(NSDictionary *)getDictionary
{
	return _data;
}

@end

@implementation NpcData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_npcId = [buffer readString];
		_character = [buffer readString];
		_gender = [buffer readInt];
		_dialogPotraitId = [buffer readString];
		_potraitId = [buffer readString];
		_portraitPosX = [buffer readInt];
		_portraitPosY = [buffer readInt];
		_level = [buffer readInt];
		_hp = [buffer readInt];
		_equipWeapon = [buffer readString];
		_equipAmor = [buffer readString];
		_equipList = [buffer readString];
		_strength = [buffer readInt];
		_intelligence = [buffer readInt];
		_agile = [buffer readInt];
		_charm = [buffer readInt];
		_eloquence = [buffer readInt];
		_lucky = [buffer readInt];
		_skillList = [buffer readString];
	}
	return self;
}

@end