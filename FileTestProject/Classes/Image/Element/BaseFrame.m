//
//  BaseFrame.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseFrame.h"

@implementation BaseFrame


-(instancetype)initWithNodeColor:(CCNodeColor *)nodeColor
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        
        CGSize contentSize = [[CCDirector sharedDirector] viewSize];
        self.contentSize = contentSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        
        if (nodeColor != nil) {
            [self addChild:nodeColor];
        }
    }
    return self;
}

-(instancetype)init
{
    if (self = [self initWithNodeColor:nil]) {
    }
    return self;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    // to swallow all the touches
}

@end
