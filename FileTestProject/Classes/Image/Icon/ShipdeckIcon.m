//
//  ShipdeckIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipdeckIcon.h"

@implementation ShipdeckIcon
{
    DeckShipSceneType _shipSceneType;
}

-(instancetype)initWithShipdeckType:(ShipdeckType)shipType
                          equipType:(int)equipType
                          sceneType:(DeckShipSceneType)shipSceneType
{
    _shipSceneType = shipSceneType;
    NSString *shipdeckStr;
    if (equipType == 0) {
        shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd.png", shipType];
    } else {
        shipdeckStr = [NSString stringWithFormat:@"Shipdeck%zd_%d.png", shipType, equipType];
    }
    if (self = [super initWithImageNamed:shipdeckStr]) {
        // TODO: 如果是可以改造的，且现在是改造模式则 显示选择框
        
    }
    return self;
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (_shipSceneType == DeckShipSceneModify) {
        // TODO：检查是否能修改，可能需要用到delegate 从上面检查
        // 如果成功则更换房间样式，注：只是暂时的，最后确定的时候才会正式换。
    }
}

@end
