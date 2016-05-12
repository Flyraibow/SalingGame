#import "DefaultDialogData.h"
@implementation DefaultDialogDic
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
			DefaultDialogData *data = [[DefaultDialogData alloc] initWithByteBuffer:buffer];
			[_data setObject:data forKey:data.dialogId];
		}
	}
	return self;
}

-(DefaultDialogData *)getDefaultDialogById:(NSString *)dialogId
{
	return [_data objectForKey:dialogId];
}

-(NSDictionary *)getDictionary
{
	return _data;
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
		_backgroundId = [buffer readString];
	}
	return self;
}

@end