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

@implementation BaseButtonGroup
{
    NSMutableArray *_buttonList;
}

-(instancetype)initWithNSArray:(NSArray *)buttonGroup
{
    if (self = [self initWithNSArray:buttonGroup CCNodeColor:nil withCloseButton:NO]) {
    }
    return self;
}

-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor
{
    
    if (self = [self initWithNSArray:buttonGroup CCNodeColor:nodeColor withCloseButton:YES]) {
    }
    return self;
}

-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor withCloseButton:(BOOL)closeButton
{
    if (self = [super initWithNodeColor:nodeColor]) {
        CGSize contentSize = [[CCDirector sharedDirector] viewSize];
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
            button.position = ccp(contentSize.width / 2, contentSize.height / 2 + (buttonNumber / 2.0 - i) * 30);
            [self addChild:button];
            [_buttonList addObject:button];
        }
    }
    return self;
}

-(void)showDefaultText:(NSString *)text
{
    CityBuildingData *buildingData = [[[DataManager sharedDataManager] getCityBuildingDic] getCityBuildingById:self.buildingNo];
    [self.baseSprite showDialog:[NSString stringWithFormat:@"%@%d",buildingData.portraitId, self.cityStle] npcName:getCityNpcName(buildingData.npcNameId) text:text];
}

-(void)confirm
{
    
}

-(void)clickCloseButton
{
    [self removeFromParent];
    [_baseSprite closeButtonGroup:self];
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
