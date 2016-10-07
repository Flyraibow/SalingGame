//
//  ShipModifyScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 4/7/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "GameShipData.h"

typedef enum : NSUInteger {
    DeckShipSceneDeck,
    DeckShipSceneModify,
    DeckShipSceneInfo,
} DeckShipSceneType;

@interface ShipScene : CCScene

@property (nonatomic, readonly, assign) DeckShipSceneType shipSceneType;
@property (nonatomic) void(^modifyComplete)(GameShipData *shipData);

-(instancetype)initWithShipData:(GameShipData *)shipData shipSceneType:(DeckShipSceneType)shipSceneType;

@end
