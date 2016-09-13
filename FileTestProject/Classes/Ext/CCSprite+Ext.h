//
//  CCSprite+Ext.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@interface CCSprite(Ext)


-(void)setRect:(CGRect)rect;

-(CGPoint)currentPositionUnderAnchor:(CGPoint)anchorPoint;

@end
