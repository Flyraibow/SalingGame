//
//  DefaultButton.h
//  FileTestProject
//
//  Created by LIU YUJIE on 1/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface DefaultButton : CCButton

/*
 * assign horizontalpadding according to the label width
 */
@property (nonatomic, readwrite, assign) CGFloat width;

+ (DefaultButton *)closeButton;

@end
