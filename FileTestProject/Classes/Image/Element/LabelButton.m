//
//  LabelButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "LabelButton.h"

@implementation LabelButton


-(instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title spriteFrame: [CCSpriteFrame frameWithImageNamed:@"ItemLabelButton_Up.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ItemLabelButton_Down.png"]  disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ItemLabelButton_Down.png"] ];
    [self setValue:@(20) forKey:@"fontSize"];
    self.scale = 0.68;
    [self setHorizontalPadding:23];
    self.togglesSelectedState = YES;
    
    return self;
}

@end
