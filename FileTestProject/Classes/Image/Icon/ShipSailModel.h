//
//  ShipSailModel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"
#import "SailSceneShipProtocol.h"
#import "GameShipData.h"


@interface ShipSailModel : CCSprite

@property (nonatomic) id<SailSceneShipProtocol> delegate;

@property (nonatomic, copy) NSString *currentCityNo;

@property (nonatomic, copy) NSString *currentSeaId;

@property (nonatomic, readonly) BOOL isMoving;

-(instancetype)initWithShipData:(GameShipData *)shipData;

-(void)setDirectionList:(NSArray *)cityList;

@end
