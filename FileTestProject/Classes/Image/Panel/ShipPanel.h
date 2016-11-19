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
#import "BasePanel.h"

typedef enum : NSUInteger {
    DeckShipSceneDeck,
    DeckShipSceneModify,
    DeckShipSceneInfo,
} DeckShipSceneType;

@interface ShipPanel : BasePanel

@property (nonatomic, readonly, assign) DeckShipSceneType shipSceneType;

@end
