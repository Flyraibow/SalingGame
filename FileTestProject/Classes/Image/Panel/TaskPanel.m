//
//  TaskPanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 5/30/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "TaskPanel.h"
#import "cocos2d.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "GameValueManager.h"
#import "GameTaskData.h"
#import "GameDataManager.h"
#import "GameCityData.h"

@implementation TaskPanel
{
  CCSprite *_bgSprite;
  TaskPanelType _type;
  __weak GameTaskData *_taskData;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
  TaskPanelType panelType = [dataList[0] intValue];
  if (panelType == TaskPanelTypeReview) {
    return [self initWithTask:[GameValueManager sharedValueManager].reservedTaskData panelType:panelType];
  } else {
    return [self initWithTask:[GameDataManager sharedGameData].myGuild.taskData panelType:panelType];
  }
}

- (instancetype)initWithTask:(GameTaskData *)taskData panelType:(TaskPanelType)panelType
{
  if (self = [super init]) {
    _type = panelType;
    _taskData = taskData;
    _contentSize = [CCDirector sharedDirector].viewSize;
    _bgSprite = [CCSprite spriteWithImageNamed:@"InfoBox.jpg"];
    _bgSprite.anchorPoint = ccp(0.5, 0.5);
    _bgSprite.positionType = CCPositionTypeNormalized;
    _bgSprite.position = ccp(0.5, 0.5);
    [self addChild:_bgSprite];
    
    if (panelType == TaskPanelTypeReview) {
      DefaultButton *btnAccept = [[DefaultButton alloc] initWithTitle:getLocalString(@"btn_accept")];
      btnAccept.positionType = CCPositionTypeNormalized;
      btnAccept.position = ccp(0.4, 0.1);
      btnAccept.scale = 0.5;
      [btnAccept setTarget:self selector:@selector(clickSureButton)];
      [_bgSprite addChild:btnAccept];
      DefaultButton *btnCancel = [[DefaultButton alloc] initWithTitle:getLocalString(@"btn_cancel")];
      btnCancel.positionType = CCPositionTypeNormalized;
      btnCancel.position = ccp(0.65, 0.1);
      btnCancel.scale = 0.5;
      [btnCancel setTarget:self selector:@selector(clickCancelButton)];
      [_bgSprite addChild:btnCancel];
    } else if (panelType == TaskPanelTypeAccepted) {
      DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
      btnClose.positionType = CCPositionTypeNormalized;
      btnClose.position = ccp(0.5, 0.1);
      btnClose.scale = 0.5;
      [btnClose setTarget:self selector:@selector(clickCancelButton)];
      [_bgSprite addChild:btnClose];
    }
    
    NSString *title = getLocalStringByInt(@"lab_taskpanel_title_", panelType);
    CCLabelTTF *label = [CCLabelTTF labelWithString:title fontName:nil fontSize:15];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.5, 0.9);
    [_bgSprite addChild:label];

    CCLabelTTF *labContent = [CCLabelTTF labelWithString:getLocalString(@"lab_taskpanel_content_str") fontName:nil fontSize:12];
    labContent.positionType = CCPositionTypeNormalized;
    labContent.anchorPoint = ccp(0, 0.5);
    labContent.position = ccp(0.2, 0.8);
    [_bgSprite addChild:labContent];
    
    CCLabelTTF *labContentStr = [CCLabelTTF labelWithString:taskData.title fontName:nil fontSize:12];
    labContentStr.positionType = CCPositionTypeNormalized;
    labContentStr.anchorPoint = ccp(0, 0.5);
    labContentStr.position = ccp(0.5, 0.8);
    [_bgSprite addChild:labContentStr];
  
    CCLabelTTF *labCity = [CCLabelTTF labelWithString:getLocalString(@"lab_taskpanel_city_str") fontName:nil fontSize:12];
    labCity.positionType = CCPositionTypeNormalized;
    labCity.anchorPoint = ccp(0, 0.5);
    labCity.position = ccp(0.2, 0.7);
    [_bgSprite addChild:labCity];
    
    CCLabelTTF *labCityStr = [CCLabelTTF labelWithString:getCityName(taskData.cityId) fontName:nil fontSize:12];
    labCityStr.positionType = CCPositionTypeNormalized;
    labCityStr.anchorPoint = ccp(0, 0.5);
    labCityStr.position = ccp(0.5, 0.7);
    [_bgSprite addChild:labCityStr];
  
    CCLabelTTF *labReward = [CCLabelTTF labelWithString:getLocalString(@"lab_taskpanel_reward_str") fontName:nil fontSize:12];
    labReward.positionType = CCPositionTypeNormalized;
    labReward.anchorPoint = ccp(0, 0.5);
    labReward.position = ccp(0.2, 0.6);
    [_bgSprite addChild:labReward];
    
    CCLabelTTF *labRewardStr = [CCLabelTTF labelWithString:getNumber(taskData.profit) fontName:nil fontSize:12];
    labRewardStr.positionType = CCPositionTypeNormalized;
    labRewardStr.anchorPoint = ccp(0, 0.5);
    labRewardStr.position = ccp(0.5, 0.6);
    [_bgSprite addChild:labRewardStr];
    
    
    CCLabelTTF *description = [CCLabelTTF labelWithString:taskData.description fontName:nil fontSize:12];
    description.positionType = CCPositionTypeNormalized;
    description.anchorPoint = ccp(0.5, 1);
    description.position = ccp(0.5, 0.5);
    [_bgSprite addChild:description];
  }
  return self;
}

- (void)clickSureButton
{
  [self removeFromParent];
  GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:self.cityId];
  [cityData startTask:_taskData];
  if (self.completionBlockWithEventId) {
    self.completionBlockWithEventId(self.successEvent);
  }
}

- (void)clickCancelButton
{
  [self removeFromParent];
  if (self.completionBlockWithEventId) {
    self.completionBlockWithEventId(self.cancelEvent);
  }
}

@end

