/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface DefaultDialogData : NSObject

@property (nonatomic,readonly) NSString *dialogId;

@property (nonatomic,readonly) NSString *npcType;

@property (nonatomic,readonly) NSString *npcParameter;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface DefaultDialogDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(DefaultDialogData *)getDefaultDialogById:(NSString *)dialogId;

@end

