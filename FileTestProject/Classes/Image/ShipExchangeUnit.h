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

@protocol ShipExchangeBuySuccessProtocol <NSObject>

-(void)ShipDealComplete;

@end

@interface ShipExchangeUnit : CCSprite

@property (nonatomic, weak) id<ShipExchangeBuySuccessProtocol> delegate;

-(instancetype)initWithShipData:(ShipData *)shipData;
-(instancetype)initWithGameShipData:(GameShipData *)gameShipData;

@end
