/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

static NSString * getItemDescription(NSString *itemId)
{
	NSString *string = [NSString stringWithFormat:@"item_description_%@", itemId];
	return NSLocalizedString(string, nil);
}

@interface ItemData : NSObject

@property (nonatomic,readonly) NSString *itemId;

@property (nonatomic,readonly) NSString *iconId;

@property (nonatomic,readonly) int category;

@property (nonatomic,readonly) int type;

@property (nonatomic,readonly) int value;

@property (nonatomic,readonly) int job;

@property (nonatomic,readonly) int price;

@property (nonatomic,readonly) NSString *ownerCityId;

@property (nonatomic,readonly) NSString *ownerGuildId;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)itemDescription;

@end

@interface ItemDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(ItemData *)getItemById:(NSString *)itemId;

@end

