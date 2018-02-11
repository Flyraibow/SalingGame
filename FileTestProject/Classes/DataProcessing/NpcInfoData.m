/* This file is generated, do not modify it !*/
#import "NpcInfoData.h"
@implementation NpcInfoData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_npcId = [buffer readString];
		_portrait = [buffer readString];
		_potraitId = [buffer readString];
		_portraitPosX = [buffer readInt];
		_portraitPosY = [buffer readInt];
		_gender = [buffer readInt];
		_character = [buffer readString];
		_zodiac = [buffer readInt];
	}
	return self;
}

@end

@implementation NpcInfoDic
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
			NpcInfoData *data = [[NpcInfoData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.npcId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(NpcInfoData *)getNpcInfoById:(NSString *)npcId
{
	return [_data objectForKey:npcId];
}

@end

