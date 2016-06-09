//
//  ProgressScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ProgressScene.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "DataButton.h"
#import "GameDataManager.h"
#import "CityScene.h"

@implementation ProgressScene
{
    ProgressType _type;
}


-(instancetype)initWithFunction:(ProgressType)type
{
    if (self = [self init]) {
        _type = type;
        
        CCSprite *bgImage = [BGImage getBgImageByName:@"bg_System.png"];
        [self addChild:bgImage];
        
        CCLabelTTF *label;
        if (type == ProgressSave) {
            label = [CCLabelTTF labelWithString:getLocalString(@"lab_save") fontName:nil fontSize:20];
        } else if (type == ProgressLoad) {
            label = [CCLabelTTF labelWithString:getLocalString(@"lab_load") fontName:nil fontSize:20];
        }
        
        label.positionType = CCPositionTypeNormalized;
        label.anchorPoint = ccp(0.5,1);
        label.position = ccp(0.5,0.85);
        [self addChild:label];
        
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(0.5,0);
        btnClose.position = ccp(0.5,0.05);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [self addChild:btnClose];
        
        DataButton *button1 = [[DataButton alloc] init];
        button1.positionType = CCPositionTypeNormalized;
        button1.position = ccp(0.5,0.6);
        button1.scaleX = bgImage.scaleX;
        button1.scaleY = bgImage.scaleY;
        [button1 setTarget:self selector:@selector(clickButton:)];
        button1.name = @"0";
        [self addChild:button1];
        
        DataButton *button2 = [[DataButton alloc] init];
        button2.positionType = CCPositionTypeNormalized;
        button2.position = ccp(0.5,0.3);
        button2.scaleX = bgImage.scaleX;
        button2.scaleY = bgImage.scaleY;
        [button2 setTarget:self selector:@selector(clickButton:)];
        button2.name = @"1";
        [self addChild:button2];
    }
    return self;
}

-(void)clickBtnClose
{
    [[CCDirector sharedDirector] popScene];
}

-(void)clickButton:(CCButton *)button
{
    [self dealWithIndex:[button.name intValue]];
}

-(void)dealWithIndex:(int)index
{
    if (_type == ProgressLoad) {
        [GameDataManager loadWithIndex:index];
        CityScene *cityScene = [[CityScene alloc] init];
        
        [[CCDirector sharedDirector] presentScene:cityScene];
        [cityScene changeCity:[GameDataManager sharedGameData].myGuild.myTeam.currentCityId];
    } else if (_type == ProgressSave) {
        [GameDataManager saveWithIndex:index];
    }
}
@end
