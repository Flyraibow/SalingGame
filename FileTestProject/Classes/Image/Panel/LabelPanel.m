//
//  LabelPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "LabelPanel.h"

@implementation LabelPanel

-(instancetype)initWithFrameName:(NSString *)frameName
{
    if (self = [super initWithImageNamed:frameName]) {
        _label = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _label.anchorPoint = ccp(0, 0.5);
        _label.positionType = CCPositionTypeNormalized;
        _label.position = ccp(0.05, 0.5);
        [self addChild:_label];
    }
    return self;
}

@end
