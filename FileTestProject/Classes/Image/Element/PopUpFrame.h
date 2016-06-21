//
//  PopUpFrame.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/20/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BaseFrame.h"

@interface PopUpFrame : BaseFrame

@property (nonatomic, readonly) CCSprite9Slice *frame;

-(instancetype)initWithSize:(CGSize)size;

-(void)setFrameSize:(CGSize)size;

@end
