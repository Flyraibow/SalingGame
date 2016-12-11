//
//  BaseData.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseData.h"

@implementation BaseData

-(NSInteger)getValueByType:(NSString *)type
{
    SEL selector = NSSelectorFromString(type);
    if ([self respondsToSelector:selector]) {
        return ((NSInteger (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    }
    return 0;
}

@end
