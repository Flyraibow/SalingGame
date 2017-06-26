//
//  BaseData.h
//  FileTestProject
//
//  Created by Yujie Liu on 12/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseData : NSObject

-(NSInteger)getValueByType:(NSString *)type;

-(NSString *)getStringByType:(NSString *)type;

@end
