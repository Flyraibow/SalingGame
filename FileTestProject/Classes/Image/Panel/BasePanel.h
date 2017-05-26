//
//  BasePanel.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@interface BasePanel : CCSprite

+ (instancetype)panelWithParameters:(NSString *)parameters;

- (instancetype)initWithDataList:(NSArray *)dataList;

@property (copy) void (^completionBlockWithEventId)(NSString *);

@property (nonatomic, readonly) NSString *successEvent;

@property (nonatomic, readwrite) NSString *cancelEvent;

@property (nonatomic, readonly) NSString *cityId;

@end
