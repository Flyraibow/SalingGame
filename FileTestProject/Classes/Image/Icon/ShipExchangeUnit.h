//
//  ShipExchangeUnit.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "GameShipData.h"

typedef enum : NSUInteger {
    ShipSceneTypeBuy,
    ShipSceneTypeSell,
    ShipSceneTypeModify,
    ShipSceneTypeInfo,
    ShipSceneTypeEquip,
} ShipSceneType;

@interface ShipExchangeUnit : CCSprite

@property (nonatomic, assign, readonly) ShipSceneType sceneType;
@property (nonatomic, weak) NSString *cityId;
@property (nonatomic) void(^selectHandler)(GameShipData *shipData);

-(instancetype)initWithGameShipData:(GameShipData *)gameShipData sceneType:(ShipSceneType)sceneType;

-(void)shipModified:(GameShipData *)shipData;

@end
