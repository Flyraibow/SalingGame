//
//  NSString(Ext).m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString(Ext)

+ (NSString *)stringWithFormat:(NSString *)format arguments:(NSArray *)arguments
{
    return [NSString stringWithFormat:format,
            (arguments.count > 0) ? arguments[0]: nil,
            (arguments.count > 1) ? arguments[1]: nil,
            (arguments.count > 2) ? arguments[2]: nil,
            (arguments.count > 3) ? arguments[3]: nil,
            (arguments.count > 4) ? arguments[4]: nil,
            (arguments.count > 5) ? arguments[5]: nil,
            (arguments.count > 6) ? arguments[6]: nil,
            (arguments.count > 7) ? arguments[7]: nil];
}
@end
