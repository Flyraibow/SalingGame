/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ByteBuffer.h"

static NSString * getJobLabel(NSString *jobId)
{
	NSString *string = [NSString stringWithFormat:@"job_name_%@", jobId];
	return NSLocalizedString(string, nil);
}

@interface JobData : NSObject

@property (nonatomic,readonly) NSString *jobId;

@property (nonatomic,readonly) NSString *conditions;

-(instancetype )initWithByteBuffer:(ByteBuffer *)buffer;

-(NSString *)jobLabel;

@end

@interface JobDic : NSObject

-(instancetype)initWithByteBuffer:(ByteBuffer *)buffer;

-(NSDictionary *)getDictionary;

-(JobData *)getJobById:(NSString *)jobId;

@end

