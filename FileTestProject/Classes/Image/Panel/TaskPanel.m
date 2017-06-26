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
    int panelType = [dataList[0] intValue];
    return [self initWithTask:[GameValueManager sharedValueManager].reservedTaskData panelType:panelType];
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
        _bgSprite.position = ccp(0.35, 0.5);
        [self addChild:_bgSprite];
        
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
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:taskData.title fontName:nil fontSize:12];
        label.positionType = CCPositionTypeNormalized;
        label.position = ccp(0.5, 0.9);
        [_bgSprite addChild:label];

        CCLabelTTF *description = [CCLabelTTF labelWithString:taskData.description fontName:nil fontSize:12];
        description.positionType = CCPositionTypeNormalized;
        description.anchorPoint = ccp(0.5, 1);
        description.position = ccp(0.5, 0.8);
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
