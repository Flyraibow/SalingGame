//
//  CannonUnitIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/20/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

static const CGFloat kCannonUnitIconWidth = 120.0;
static const CGFloat kCannonUnitIconHeight = 35.0;

@protocol CannonUnitIconDelegate <NSObject>

-(void)selectCannon:(int)cannonPower;

@end

@interface CannonUnitIcon : CCSprite

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id<CannonUnitIconDelegate> delegate;

-(instancetype)initWithCannonPower:(int)cannonPower;

@end
