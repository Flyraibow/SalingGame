//
//  ShipModifyScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/7/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipScene.h"

@implementation ShipScene
{
    GameShipData *_shipData;
}

-(instancetype)initWithShipData:(GameShipData *)shipData
{
    if (self = [super init]) {
        _shipData = shipData;
    }
    return self;
}

@end
