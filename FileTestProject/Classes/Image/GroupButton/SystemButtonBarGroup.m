//
//  SystemButtonBarGroup.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/27/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "SystemButtonBarGroup.h"
#import "DataManager.h"
#import "DefaultButton.h"
#import "GameEventManager.h"

@implementation SystemButtonBarGroup

-(instancetype)init
{
  if (self = [super init]) {
    NSDictionary *dict = [[DataManager sharedDataManager].getCitySystemBarDic getDictionary];
    for(int i = 1; i <= 5; ++i) {
      CitySystemBarData *barData = [dict objectForKey:[@(i) stringValue]];
      DefaultButton *button1 = [DefaultButton buttonWithTitle: [barData buttonLabel]];
      button1.anchorPoint = ccp(0,0);
      button1.name = barData.bottomBarId;
      button1.positionType = CCPositionTypePoints;
      button1.width = 130;
      button1.position = ccp(96 * (i - 1), 0);
      [button1 setTarget:self selector:@selector(clickSystemButton:)];
      [self addChild:button1];
    }
  }
  return self;
}

-(void)clickSystemButton:(DefaultButton *)button
{
  // TODO: USE the excel to control it
  CitySystemBarData *barData = [[DataManager sharedDataManager].getCitySystemBarDic getCitySystemBarById:button.name];
  [[GameEventManager sharedEventManager] startEventId:barData.eventAction];
}

@end
