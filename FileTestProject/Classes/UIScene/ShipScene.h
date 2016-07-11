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

@protocol ShipSceneModifiedDelegate <NSObject>

-(void)shipModified:(GameShipData *)shipData;

@end

@interface ShipScene : CCScene

@property (nonatomic, readonly, assign) DeckShipSceneType shipSceneType;
@property (nonatomic, weak) id<ShipSceneModifiedDelegate> delegate;

-(instancetype)initWithShipData:(GameShipData *)shipData shipSceneType:(DeckShipSceneType)shipSceneType;

@end
