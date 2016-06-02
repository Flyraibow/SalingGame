//
//  MenuPage.m
//  FileTestProject
//
//  Created by LIU YUJIE on 1/29/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "MenuPage.h"
#import "BGImage.h"
#import "CityScene.h"
#import "DefaultButton.h"
#import "ProgressScene.h"
#import "GameDataManager.h"
#import "CGStoryScene.h"
#import "SelectPeopleScene.h"
#import "DataManager.h"
#import "DialogPanel.h"
#import "LocalString.h"
#import "DuelScene.h"
#import "ItemInfoPanel.h"
#import "ItemBrowsePanel.h"
#import "NSString+Ext.h"

@interface MenuPage() <DialogInteractProtocol>

@end

@implementation MenuPage


- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    NSLog(@"Move to the the test page");
    
    CCSprite *bgImage = [BGImage getBgImageByName:@"bg1.jpg"];
    [self addChild:bgImage];
    
    CGSize contentSize = [CCDirector sharedDirector].viewSize;
    DefaultButton *btnStart = [DefaultButton buttonWithTitle:@"Start"];
    btnStart.positionType = CCPositionTypePoints;
    btnStart.position = ccp(contentSize.width / 2 ,100);
    [self addChild:btnStart];
    [btnStart setTarget:self selector:@selector(clickStart)];
    
    DefaultButton *btnContinue = [DefaultButton buttonWithTitle:@"Continue"];
    btnContinue.positionType = CCPositionTypePoints;
    btnContinue.position = ccp(contentSize.width / 2 ,60);
    [btnContinue setTarget:self selector:@selector(clickContinue)];
    [self addChild:btnContinue];
    
    DefaultButton *btnTest = [DefaultButton buttonWithTitle:@"Test"];
    btnTest.positionType = CCPositionTypePoints;
    btnTest.position = ccp(contentSize.width / 2 ,20);
    [btnTest setTarget:self selector:@selector(clickTest)];
    [self addChild:btnTest];

    [[OALSimpleAudio sharedInstance] playBg:@"bgBGM.m4v" loop:YES];
    
    return self;
}

-(void)clickStart
{
    [[OALSimpleAudio sharedInstance] playEffect:@"button.wav"];
    
    NSDictionary *dictionary = [[[DataManager sharedDataManager] getRoleInitialDic] getDictionary];
    [[CCDirector sharedDirector] presentScene:[[SelectPeopleScene alloc] initWithInitialList:dictionary]];
    
    
//    GameGuildData *guildData = [[GameDataManager sharedGameData].guildDic objectForKey:@"1"];
//    // init the data
//    [[GameDataManager sharedGameData] initMyGuildWithGameGuildData:guildData];
//    [[GameDataManager sharedGameData] setYear:1504 month:3 day:29];
//    [[GameDataManager sharedGameData].myGuild gainMoney:1000000];
//    // select the role
//
//    
//    [[CCDirector sharedDirector] presentScene:[[CityScene alloc] initWithCityNo:@"1"]];
    
}


-(void)clickContinue
{
    [[OALSimpleAudio sharedInstance] playEffect:@"button.wav"];
    [[CCDirector sharedDirector] pushScene:[[ProgressScene alloc] initWithFunction:ProgressLoad]];
    
}

-(void)clickTest
{
//    DialogPanel *panel = [[DialogPanel alloc] init];
//    NSString *npcName = getNpcFullName(@"1");
//    NSString *text = getStoryText(@"12");
//    panel.delegate = self;
//    [panel setDefaultDialog:@"dialog_buy_item" arguments:@[@"东方宝典", @"1000"] cityStyle:1];
//    [self addChild:panel];
    
//    DuelScene *duelScene = [[DuelScene alloc] initWithRoleId:@"1" roleId:@"2"];
//    [[CCDirector sharedDirector] pushScene:duelScene];
    CGStoryScene *storyScene = [[CGStoryScene alloc] initWithStoryId:@"2"];
    [[CCDirector sharedDirector] pushScene:storyScene];
}


-(void)selectIndex:(int)index
{
    NSLog(@"select : %d", index);
}

@end
