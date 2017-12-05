/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface TaskData : NSObject

@property (nonatomic,readonly) NSString *taskStyleId;

@property (nonatomic,readonly) int taskDescriptionId;

@property (nonatomic,readonly) int taskTitleId;

@property (nonatomic,readonly) NSString *condition;

@property (nonatomic,readonly) NSString *targetItem;

@property (nonatomic,readonly) int startCity;

@property (nonatomic,readonly) int destCity;

@property (nonatomic,readonly) int destBuilding;

@property (nonatomic,readonly) int priority;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface TaskDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(TaskData *)getTaskById:(NSString *)taskStyleId;

@end

