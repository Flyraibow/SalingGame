/* This file is generated, do not modify it !*/
#import "NpcData.h"
@implementation NpcData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
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
		_luck = [buffer readInt];
		_skillList = [buffer readString];
	}
	return self;
}

@end

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
-(NSDictionary *)getDictionary
{
	return _data;
}
-(NpcData *)getNpcById:(NSString *)npcId
{
	return [_data objectForKey:npcId];
}

@end

