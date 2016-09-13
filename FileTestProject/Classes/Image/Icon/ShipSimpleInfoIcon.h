//
//  ShipInfoSimpleIcon.h
//  FileTestProject
//
//  Created by Yujie Liu on 9/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@class GameShipData;
@interface ShipSimpleInfoIcon : CCSprite

@property (nonatomic, assign) BOOL inTeam;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) CGPoint destinyPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGFloat currentAlpha;
@property (nonatomic, assign) CGFloat destinyAlpha;

-(instancetype)initWithShipData:(GameShipData *)shipData;

-(void)setTarget:(id)target selector:(SEL)selector;

@end
