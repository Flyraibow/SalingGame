//
//  ProgressScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ProgressPanel.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "DataButton.h"
#import "GameDataManager.h"
#import "CityScene.h"
#import "GameEventManager.h"

@implementation ProgressPanel
{
    ProgressType _type;
}

-(instancetype)initWithDataList:(NSArray *)dataList
{
    return [self initWithFunction:[dataList[0] integerValue]];
}

-(instancetype)initWithFunction:(ProgressType)type
{
    if (self = [super init]) {
        _type = type;
        CCSprite *bgImage = [BGImage getBgImageByName:@"bg_System.png"];
        [self addChild:bgImage];
        
        CCLabelTTF *label;
        if (_type == ProgressSave) {
            label = [CCLabelTTF labelWithString:getLocalString(@"lab_save") fontName:nil fontSize:20];
        } else if (_type == ProgressLoad) {
            label = [CCLabelTTF labelWithString:getLocalString(@"lab_load") fontName:nil fontSize:20];
        }
        
        label.positionType = CCPositionTypeNormalized;
        label.anchorPoint = ccp(0.5,1);
        label.position = ccp(0.5,0.85);
        [self addChild:label];
        
        for (int i = 0; i < 5; ++i) {
            DefaultButton *button = [[DefaultButton alloc] initWithTitle:[self buttonTitleForIndex:i]];
            button.positionType = CCPositionTypeNormalized;
            button.position = ccp(0.5,0.7 - i * 0.11);
            [button setTarget:self selector:@selector(clickButton:)];
            button.name = [@(i) stringValue];
            [button setHorizontalPadding:120];
            [self addChild:button];
        }
        
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(0.5,0);
        btnClose.position = ccp(0.5,0.05);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [self addChild:btnClose];
    }
    return self;
}

-(void)clickBtnClose
{
    [self removeFromParent];
}

-(void)clickButton:(CCButton *)button
{
    int index = [button.name intValue];
    if (_type == ProgressLoad) {
        [GameDataManager loadWithIndex:index];
        CityScene *cityScene = [[CityScene alloc] init];
        
        [[CCDirector sharedDirector] presentScene:cityScene];
        [[GameEventManager sharedEventManager] clear];
        [cityScene changeCity:[GameDataManager sharedGameData].myGuild.myTeam.currentCityId];
    } else if (_type == ProgressSave) {
        [GameDataManager saveWithIndex:index];
        button.title = [self buttonTitleForIndex:index];
    }
}

- (NSString *)buttonTitleForIndex:(int)index
{
    NSString *str = [[GameDataManager sharedProgressData] descriptionForIndex:index];
    if (!str) {
        str = @"No Data";
    }
    return [NSString stringWithFormat:@"%d  %@",index + 1, str];
}
@end
