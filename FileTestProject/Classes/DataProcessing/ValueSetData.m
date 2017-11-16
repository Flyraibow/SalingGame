/* this file is generated */
#import "ValueSetData.h"
@implementation ValueSetDic
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
			ValueSetData *data = [[ValueSetData alloc] initWithByteBuffer:buffer];
			if ([_groupData objectForKey:data.settingId] == nil) {
				[_groupData setObject:[NSMutableArray new] forKey:data.settingId];
			}
			[[_groupData objectForKey:data.settingId] addObject:data];
		}
	}
	return self;
}

-(NSArray *)getValueSetGroupByGroupId:(NSString *)groupIdName
{
	return [_groupData objectForKey:groupIdName];
}

@end

@implementation ValueSetData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_settingId = [buffer readString];
		_command = [buffer readInt];
		_hint = [buffer readInt];
		_parameter1 = [buffer readString];
		_parameter2 = [buffer readString];
		_parameter3 = [buffer readString];
		_parameter4 = [buffer readString];
	}
	return self;
}

@end