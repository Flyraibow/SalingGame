//
//  ShipExchange.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "ShipExchangeUnit.h"

@interface ShipExchangeScene : CCScene

@property (nonatomic, assign, readonly) ShipSceneType sceneType;

-(instancetype)initWithCityNo:(NSString *)cityNo;

-(instancetype)initWithShipList:(NSArray *)shipList sceneType:(ShipSceneType)sceneType;

@end
