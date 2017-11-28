//
//  LabelFrame.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/26/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface LabelFrame : CCSprite

@property (nonatomic, readwrite, copy) NSString *string;

- (instancetype)initWithPrefix:(NSString *)prefix;

@end
