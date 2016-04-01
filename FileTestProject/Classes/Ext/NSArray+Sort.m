//
//  NSArray+Sort.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/3/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "NSArray+Sort.h"

@implementation NSArray(Sort)

-(NSArray *)sortByNumberAscending:(BOOL)ascending
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return ascending?NSOrderedDescending:NSOrderedAscending;
        else if ([obj1 intValue] < [obj2 intValue])
            return ascending?NSOrderedAscending:NSOrderedDescending;
        return NSOrderedSame;
    }];
}

@end
