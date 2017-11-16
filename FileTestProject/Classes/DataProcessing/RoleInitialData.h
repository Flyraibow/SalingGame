/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

@interface RoleInitialData : NSObject

@property (nonatomic,readonly) NSString *roldId;

@property (nonatomic,readonly) int rolePhotoId;

@property (nonatomic,readonly) NSString *guildId;

@property (nonatomic,readonly) int dateBirthMonth;

@property (nonatomic,readonly) int dataBirthDay;

@property (nonatomic,readonly) int startYear;

@property (nonatomic,readonly) int startMonth;

@property (nonatomic,readonly) int startDay;

@property (nonatomic,readonly) int gender;

@property (nonatomic,readonly) int money;

@property (nonatomic,readonly) NSString *startCityId;

@property (nonatomic,readonly) NSString *startStoryId;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

@end

@interface RoleInitialDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(RoleInitialData *)getRoleInitialById:(NSString *)roldId;

@end

