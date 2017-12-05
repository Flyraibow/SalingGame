/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

static NSString * getCategoryUpdateLabel(NSString *categoryUpdateId)
{
	NSString *string = [NSString stringWithFormat:@"category_update_%@", categoryUpdateId];
	return NSLocalizedString(string, nil);
}

@interface CategoryUpdateData : NSObject

@property (nonatomic,readonly) NSString *categoryUpdateId;

@property (nonatomic,readonly) NSSet *updateMonth;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)categoryUpdateLabel;

@end

@interface CategoryUpdateDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(CategoryUpdateData *)getCategoryUpdateById:(NSString *)categoryUpdateId;

@end

