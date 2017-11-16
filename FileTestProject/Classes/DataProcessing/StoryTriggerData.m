/* This file is generated, do not modify it !*/
#import "StoryTriggerData.h"
@implementation StoryTriggerData
-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_storyId = [buffer readString];
		_locked = [buffer readInt];
		_heroId = [buffer readString];
		_cityId = [buffer readString];
		_prefixStoryId = [buffer readString];
		_buildingId = [buffer readString];
		_month = [buffer readString];
		_day = [buffer readString];
		_year = [buffer readString];
		_cityPercentage = [buffer readInt];
		_commerce = [buffer readInt];
		_military = [buffer readInt];
		_npcInTeam = [buffer readString];
		_npcNotInTeam = [buffer readString];
		_repeatable = [buffer readInt];
		_forbiddenStoryId = [buffer readString];
		_priority = [buffer readInt];
		_money = [buffer readLong];
	}
	return self;
}

@end

@implementation StoryTriggerDic
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
			StoryTriggerData *data = [[StoryTriggerData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.storyId];
		}
	}
	return self;
}
-(NSDictionary *)getDictionary
{
	return _data;
}
-(StoryTriggerData *)getStoryTriggerById:(NSString *)storyId
{
	return [_data objectForKey:storyId];
}

@end

