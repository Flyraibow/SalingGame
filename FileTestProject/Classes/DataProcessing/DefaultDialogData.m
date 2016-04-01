#import "DefaultDialogData.h"
@implementation DefaultDialogDic
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
			DefaultDialogData *data = [[DefaultDialogData alloc] initWithByteBuffer:buffer];
			if ([_groupData objectForKey:data.dialogId] == nil) {
				[_groupData setObject:[NSMutableArray new] forKey:data.dialogId];
			}
			[[_groupData objectForKey:data.dialogId] addObject:data];
		}
	}
	return self;
}

-(NSMutableArray *)getDefaultDialogGroupByGroupId:(NSString *)groupIdName
{
	return [_groupData objectForKey:groupIdName];
}

@end

@implementation DefaultDialogData

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer
{
	self = [self init];
	if (self) {
		_dialogId = [buffer readString];
		_npcType = [buffer readInt];
		_npcParameter = [buffer readInt];
		_photoId = [buffer readString];
		_dialogName = [buffer readString];
		_dialogText = [buffer readString];
		_backgroundId = [buffer readString];
	}
	return self;
}

@end