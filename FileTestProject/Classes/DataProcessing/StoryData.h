/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"


@interface StoryData : NSObject

@property (nonatomic,readonly) NSString *storyId;

@property (nonatomic,readonly) int command;

@property (nonatomic,readonly) NSString *parameter1;

@property (nonatomic,readonly) NSString *parameter2;

@property (nonatomic,readonly) NSString *parameter3;

@property (nonatomic,readonly) NSString *parameter4;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface StoryDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSArray *)getStoryGroupByGroupId:(NSString *)groupId;

@end

