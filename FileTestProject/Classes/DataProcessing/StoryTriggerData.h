/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface StoryTriggerData : NSObject

@property (nonatomic,readonly) NSString *storyId;

@property (nonatomic,readonly) int locked;

@property (nonatomic,readonly) NSString *heroId;

@property (nonatomic,readonly) NSString *cityId;

@property (nonatomic,readonly) NSString *prefixStoryId;

@property (nonatomic,readonly) NSString *buildingId;

@property (nonatomic,readonly) NSString *month;

@property (nonatomic,readonly) NSString *day;

@property (nonatomic,readonly) NSString *year;

@property (nonatomic,readonly) int cityPercentage;

@property (nonatomic,readonly) int commerce;

@property (nonatomic,readonly) int military;

@property (nonatomic,readonly) NSString *npcInTeam;

@property (nonatomic,readonly) NSString *npcNotInTeam;

@property (nonatomic,readonly) int repeatable;

@property (nonatomic,readonly) NSString *forbiddenStoryId;

@property (nonatomic,readonly) int priority;

@property (nonatomic,readonly) long money;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface StoryTriggerDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(StoryTriggerData *)getStoryTriggerById:(NSString *)storyId;

@end

