//
//  BaseButtonGroup.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseButtonGroup.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "CityBuildingGroup.h"
#import "DataManager.h"
#import "BGImage.h"
#import "DataManager.h"
#import "GameConditionManager.h"
#import "GameEventManager.h"

@implementation BaseButtonGroup
{
    NSMutableArray *_buttonList;
}

-(instancetype)initWithEventActionData:(EventActionData *)eventData
{
    NSAssert([eventData.eventType isEqualToString:@"selectlist"],
             @"BaseButtonGroup Event type is wrong, type %@ != selectlist", eventData.eventType);
    NSArray *rawList = [eventData.parameter componentsSeparatedByString:@";"];
    NSMutableArray *buttonList = [NSMutableArray new];
    for (NSString *buttonId in rawList) {
        if (buttonId.length > 0) {
            SelectListData *selectedData = [[DataManager sharedDataManager].getSelectListDic getSelectListById:buttonId];
            NSAssert(selectedData, @"selectedData is not set for %@", buttonId);
            if (selectedData) {
                if ([[GameConditionManager sharedConditionManager] checkConditions:selectedData.conditionList]) {
                    DefaultButton *button = [DefaultButton buttonWithTitle:getSelectLab(selectedData.selectId)];
                    button.name = buttonId;
                    [button setTarget:self selector:@selector(clickButton:)];
                    [buttonList addObject:button];
                }
            }
        }
    }
    if (self = [self initWithNSArray:buttonList CCNodeColor:[BGImage getShadowForBackground]]) {
        
    }
    return self;
}

-(instancetype)initWithNSArray:(NSArray *)buttonGroup
{
    if (self = [self initWithNSArray:buttonGroup CCNodeColor:nil withCloseButton:NO]) {
    }
    return self;
}

-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor
{
    
    if (self = [self initWithNSArray:buttonGroup CCNodeColor:nodeColor withCloseButton:NO]) {
    }
    return self;
}

-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor withCloseButton:(BOOL)closeButton
{
    if (self = [super init]) {
        if (nodeColor) {
            [self addChild:nodeColor];
        }
        NSArray *array;
        if (closeButton) {
            DefaultButton *closeButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
            [closeButton setTarget:self selector:@selector(clickCloseButton)];
            array = [buttonGroup arrayByAddingObject:closeButton];
        } else {
            array = buttonGroup;
        }
        _buttonList = [NSMutableArray new];
        NSUInteger buttonNumber = array.count;
        for (int i = 0; i < buttonNumber; ++i) {
            CCButton *button = [array objectAtIndex:i];
            button.positionType = CCPositionTypePoints;
            button.anchorPoint = ccp(0.5, 0.5);
            button.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2 + (buttonNumber / 2.0 - i) * 30);
            [self addChild:button];
            [_buttonList addObject:button];
        }
    }
    return self;
}

-(void)clickCloseButton
{
    [self removeFromParent];
    if (self.cancelEvent) {
        self.completionBlockWithEventId(self.cancelEvent);
    }
}

-(void)clickButton:(DefaultButton *)button
{
    [[GameEventManager sharedEventManager] startEventId:button.name];
}

-(void)setCallback:(void(^)(int index))handler
{
    for (int i = 0; i < _buttonList.count; ++i) {
        CCButton *button = [_buttonList objectAtIndex:i];
        __block int ii = i;
        [button setBlock:^(id sender) {
            handler(ii);
        }];
    }
}

@end
