//
//  LabelPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface LabelPanel : CCSprite

@property (nonatomic, readonly) CCLabelTTF *label;

-(instancetype)initWithFrameName:(NSString *)frameName;

@end
