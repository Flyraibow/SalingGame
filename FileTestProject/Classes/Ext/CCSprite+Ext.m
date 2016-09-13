//
//  CCSprite+Ext.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite+Ext.h"

@implementation CCSprite(Ext)

-(void)setRect:(CGRect)rect
{
    self.positionType = CCPositionTypePoints;
    self.anchorPoint = ccp(0,0);
    self.scaleX = rect.size.width / self.contentSize.width;
    self.scaleY = rect.size.height / self.contentSize.height;
    self.position = rect.origin;
}

-(CGPoint)currentPositionUnderAnchor:(CGPoint)anchorPoint
{
    return CGPointZero;
}

@end
