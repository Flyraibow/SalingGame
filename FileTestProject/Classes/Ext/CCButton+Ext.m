//
//  CCButton+Ext.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/15/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "CCButton+Ext.h"
#import "CCSpriteFrame.h"

@implementation CCButton(Ext)

+(id)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName;
{
  CCSpriteFrame *selectUp = [CCSpriteFrame frameWithImageNamed:imageName];
  CCSpriteFrame *selectDown = [CCSpriteFrame frameWithImageNamed:highlightedImageName];
  return [[self alloc] initWithTitle:@"" spriteFrame:selectUp highlightedSpriteFrame:selectDown disabledSpriteFrame:selectUp];
}


@end
