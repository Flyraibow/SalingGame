//
//  LabelFrame.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/26/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface LabelFrame : CCSprite9Slice

@property (nonatomic, readwrite, copy) NSString *string;
@property (nonatomic, assign) BOOL center;
@property (nonatomic, assign) BOOL vertical;

- (instancetype)initWithPrefix:(NSString *)prefix;

-(void)setTarget:(id)target selector:(SEL)selector;

@end
