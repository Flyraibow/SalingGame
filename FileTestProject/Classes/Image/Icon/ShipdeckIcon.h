//
//  ShipdeckIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 4/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "ShipScene.h"

typedef enum : NSUInteger {
    ShipdeckTypeOperationSail,
    ShipdeckTypeLookout,
    ShipdeckTypeDeck,
    ShipdeckTypeSteerRoom,
    ShipdeckTypeCaptainRoom,
    ShipdeckTypeViseCaptainRoom,
    ShipdeckTypeFunctionRoom,
    ShipdeckTypeStorageRoom,
    
} ShipdeckType;

@interface ShipdeckIcon : CCSprite

-(instancetype)initWithShipdeckType:(ShipdeckType)shipType equipType:(int)equipType sceneType:(DeckShipSceneType)shipSceneType;

@end
