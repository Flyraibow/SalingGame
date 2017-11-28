//
//  BasePanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"
#import "InvestPanel.h"
#import "SailorNumberPanel.h"
#import "TradePanel.h"
#import "GameDataManager.h"
#import "GameValueManager.h"
#import "GameEventManager.h"
#import "BGImage.h"

@implementation BasePanel
{
  NSString *_successEvent;
  NSString *_cancelEvent;
  NSString *_cityId;
}

@synthesize successEvent = _successEvent;
@synthesize cancelEvent = _cancelEvent;
@synthesize cityId = _cityId;

+ (instancetype)panelWithParameters:(NSString *)parameters;
{
  NSMutableArray *paraList = [[parameters componentsSeparatedByString:@";"] mutableCopy];
  NSString *spriteClassName = paraList[0];
  NSString *successEvent = paraList[1];
  NSString *cancelEvent = paraList[2];
  [paraList removeObjectsInRange:NSMakeRange(0, 3)];
  Class cls = NSClassFromString(spriteClassName);
  BasePanel *basePanel = [(BasePanel *)[cls alloc] initWithSuccessEvent:successEvent cancelEvent:cancelEvent dataList:paraList];
  NSAssert(basePanel, @"Windows Panel is nil : %@", spriteClassName);
  return basePanel;
}

- (instancetype)init
{
  if (self = [self initWithoutBackground]) {
    [self addChild:[BGImage getTransparentBackground]];
  }
  return self;
}

- (instancetype)initWithoutBackground
{
  if (self = [super init]) {
    CGSize contentSize = [CCDirector sharedDirector].viewSize;
    self.contentSize = contentSize;
    self.positionType = CCPositionTypeNormalized;
    self.position = ccp(0.5, 0.5);
    if ([GameDataManager isInitialed]) {
      _cityId = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
    }
  }
  return self;
}

- (instancetype)initWithSuccessEvent:(NSString *)successEvent cancelEvent:(NSString *)cancelEvent dataList:(NSArray *)dataList
{
  self = [self initWithDataList:dataList];
  if (self) {
    _successEvent = successEvent;
    _cancelEvent = cancelEvent;
  }
  
  return self;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  if (self = [self init]) {
  }
  return self;
}

- (void)removeFromParent
{
  if ([GameEventManager sharedEventManager].topPanel == self) {
    [[GameEventManager sharedEventManager] popPanel];
  } else {
    [super removeFromParent];
  }
}

@end

