#import "StoryData.h"
@implementation StoryDic
{
	NSMutableDictionary *_groupData;
}

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		int amount = [buffer readInt];
		_groupData = [NSMutableDictionary new];
		for (int i = 0; i < amount; ++i) {
			StoryData *data = [[StoryData alloc] initWithByteBuffer:buffer];
			if ([_groupData objectForKey:data.storyId] == nil) {
				[_groupData setObject:[NSMutableArray new] forKey:data.storyId];
			}
			[[_groupData objectForKey:data.storyId] addObject:data];
		}
	}
	return self;
}

-(NSArray *)getStoryGroupByGroupId:(NSString *)groupIdName
{
	return [_groupData objectForKey:groupIdName];
}

@end

@implementation StoryData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_storyId = [buffer readString];
		_command = [buffer readInt];
		_parameter1 = [buffer readString];
		_parameter2 = [buffer readString];
		_parameter3 = [buffer readString];
		_parameter4 = [buffer readString];
	}
	return self;
}

@end