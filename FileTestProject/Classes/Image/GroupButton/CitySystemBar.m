//
//  CitySystemBar.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CitySystemBar.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "SailMapScene.h"
#import "RolePanel.h"
#import "SailorNumberPanel.h"
#import "GamePanelManager.h"
#import "GameEventManager.h"
#import "GameValueManager.h"
#import "GameDataObserver.h"
#import "DataManager.h"

@interface GameDataObserver() <NSCopying>

@end

@implementation CitySystemBar
{
  CCLabelTTF *_labMyMoney;
}

-(instancetype)init
{
  self = [super initWithImageNamed:@"citySystemBar.png"];
  if (self) {
    self.anchorPoint = ccp(0,0);
    self.scale = [CCDirector sharedDirector].viewSize.width * 0.75 / self.contentSize.width;
    self.positionType = CCPositionTypePoints;
    self.position = ccp(0, 0);
    
    NSDictionary *dict = [[DataManager sharedDataManager].getCitySystemBarDic getDictionary];
    for(int i = 1; i <= 5; ++i) {
      CitySystemBarData *barData = [dict objectForKey:[@(i) stringValue]];
      DefaultButton *button1 = [DefaultButton buttonWithTitle: [barData buttonLabel]];
      button1.anchorPoint = ccp(0,0.5);
      button1.name = barData.bottomBarId;
      button1.positionType = CCPositionTypeNormalized;
      button1.position = ccp(0.03 + 0.19 * (i - 1), 0.25);
      [button1 setTarget:self selector:@selector(clickSystemButton:)];
      [self addChild:button1];
    }
    
    CCLabelTTF *labMoney = [CCLabelTTF labelWithString:getLocalString(@"lab_hold_money") fontName:nil fontSize:11];
    labMoney.anchorPoint = ccp(0,0.5);
    labMoney.positionType = CCPositionTypeNormalized;
    labMoney.position = ccp(0.8, 0.84);
    [self addChild:labMoney];
    
    _labMyMoney = [CCLabelTTF labelWithString:[@([GameDataManager sharedGameData].myGuild.money) stringValue]  fontName:nil fontSize:12];
    _labMyMoney.anchorPoint = ccp(1, 0.5);
    _labMyMoney.positionType = CCPositionTypeNormalized;
    _labMyMoney.position = ccp(0.98, 0.84);
    [self addChild:_labMyMoney];
    
    [[GameDataObserver sharedObserver] addListenerForKey:LISTENNING_KEY_MONEY target:self selector:@selector(updateMoney:)];
  }
  return self;
}

-(id)copyWithZone:(NSZone *)zone
{
  return self;
}

-(void)removeAllChildrenWithCleanup:(BOOL)cleanup
{
  [super removeAllChildrenWithCleanup:cleanup];
  [[GameDataObserver sharedObserver] removeAllListenersForTarget:self];
}

-(void)updateMoney:(NSNumber *)money
{
  _labMyMoney.string = [money stringValue];
}

-(void)clickSystemButton:(DefaultButton *)button
{
  // TODO: USE the excel to control it
  CitySystemBarData *barData = [[DataManager sharedDataManager].getCitySystemBarDic getCitySystemBarById:button.name];
  [[GameEventManager sharedEventManager] startEventId:barData.eventAction];
}

@end

