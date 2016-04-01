//
//  NSSet+Sort.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/3/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "NSSet+Sort.h"

@implementation NSSet(Sort)


-(NSArray *)sortByNumberAscending:(BOOL)ascending
{
    return [self sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:ascending comparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return NSOrderedDescending;
        else if ([obj1 intValue] < [obj2 intValue])
            return NSOrderedAscending;
        
        return NSOrderedSame;
    }]]];
}

@end
