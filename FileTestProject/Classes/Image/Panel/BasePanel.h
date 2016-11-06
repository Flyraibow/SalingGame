//
//  BasePanel.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@interface BasePanel : CCSprite

- (instancetype)initWithArray:(NSArray *)array;

@property (copy) void (^completionBlockWithEventId)(NSString *);

@end
