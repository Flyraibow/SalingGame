//
//  ShipExchangeUnit.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "ShipData.h"
#import "GameShipData.h"

typedef enum : NSUInteger {
    ShipSceneTypeBuy,
    ShipSceneTypeSell,
    ShipSceneTypeModify,
    ShipSceneTypeInfo,
} ShipSceneType;

@protocol ShipExchangeBuySuccessProtocol <NSObject>

-(void)ShipDealComplete;

@end

@interface ShipExchangeUnit : CCSprite

@property (nonatomic, weak) id<ShipExchangeBuySuccessProtocol> delegate;
@property (nonatomic, assign, readonly) ShipSceneType sceneType;
@property (nonatomic, weak) NSString *cityId;

-(instancetype)initWithGameShipData:(GameShipData *)gameShipData sceneType:(ShipSceneType)sceneType;

@end
