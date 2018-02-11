//
//  DefaultButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 1/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DefaultButton.h"
#import "LocalString.h"

@implementation DefaultButton

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title spriteFrame: [CCSpriteFrame frameWithImageNamed:@"button_up.png"]];
    [self setValue:@(20) forKey:@"fontSize"];
    self.scale = 0.68;
    [self setHorizontalPadding:23];
    
    return self;
}


+ (DefaultButton *)closeButton
{
  return [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
}

- (void)setWidth:(CGFloat)width
{
  _width = width;
  self.horizontalPadding = (width - self.label.contentSize.width) / 2;
}

@end
