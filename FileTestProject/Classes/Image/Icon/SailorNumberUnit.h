//
//  SailorNumberUnit.h
//  FileTestProject
//
//  Created by LIU YUJIE on 7/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameShipData.h"
#import "SailorNumberPanel.h"

@interface SailorNumberUnit : CCSprite

@property (nonatomic, weak) id<SailorNumberPanelDelegate> delegate;

@property (nonatomic, weak) GameShipData *shipData;

@property (nonatomic, readwrite) int sailorNumber;

- (instancetype)initWithShipData:(GameShipData *)shipData;

@end
