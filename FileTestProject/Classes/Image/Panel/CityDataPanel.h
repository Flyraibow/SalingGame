//
//  CityDataPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
  CityDataPanelSailRead,
  CityDataPanelSailGo,
  CityDataPanelSailTradeInfo,
  CityDataPanelPlaza,
} CityDataPanelType;

@interface CityDataPanel : CCSprite

@property (nonatomic, readonly, assign) CityDataPanelType sceneType;

-(instancetype)initWithCityNo:(NSString *)cityNo sceneType:(CityDataPanelType)sceneType;

-(void)setCityNo:(NSString *)cityNo;

@end

