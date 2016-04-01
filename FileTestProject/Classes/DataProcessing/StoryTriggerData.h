#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface StoryTriggerData : NSObject

@property (nonatomic, readonly) NSString *storyId;
@property (nonatomic, readonly) NSString *heroId;
@property (nonatomic, readonly) NSString *cityId;
@property (nonatomic, readonly) NSString *prefixStoryId;
@property (nonatomic, readonly) NSString *buildingId;
@property (nonatomic, readonly) NSString *month;
@property (nonatomic, readonly) NSString *day;
@property (nonatomic, readonly) NSString *year;
@property (nonatomic, readonly) int cityPercentage;
@property (nonatomic, readonly) int commerce;
@property (nonatomic, readonly) int military;
@property (nonatomic, readonly) NSString *npcInTeam;
@property (nonatomic, readonly) NSString *npcNotInTeam;
@property (nonatomic, readonly) int repeatable;
@property (nonatomic, readonly) NSString *forbiddenStoryId;
@property (nonatomic, readonly) int priority;
@property (nonatomic, readonly) NSInteger money;

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface StoryTriggerDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(StoryTriggerData *)getStoryTriggerById:(NSString *)storyId;

-(NSDictionary *)getDictionary;

@end