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
#import "GameDataManager.h"
#import "ProgressPanel.h"
#import "CGStoryScene.h"
#import "SelectPeopleScene.h"
#import "DataManager.h"
#import "DialogPanel.h"
#import "LocalString.h"
#import "DuelScene.h"
#import "ItemInfoPanel.h"
#import "ItemBrowsePanel.h"
#import "NSString+Ext.h"
#import "CannonSelectionPanel.h"

@interface MenuPage()

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
    
    CCSprite *bgImage = [BGImage getBgImageByName:@"bg_System.png"];
    [self addChild:bgImage];
    
    DefaultButton *btnStart = [DefaultButton buttonWithTitle:getLocalString(@"btn_start")];
    btnStart.positionType = CCPositionTypeNormalized;
    btnStart.position = ccp(0.5 ,0.6);
    [self addChild:btnStart];
    [btnStart setTarget:self selector:@selector(clickStart)];
    
    DefaultButton *btnContinue = [DefaultButton buttonWithTitle:getLocalString(@"btn_continue")];
    btnContinue.positionType = CCPositionTypeNormalized;
    btnContinue.position = ccp(0.5 ,0.5);
    [btnContinue setTarget:self selector:@selector(clickContinue)];
    [self addChild:btnContinue];
    
    DefaultButton *btnTest = [DefaultButton buttonWithTitle:getLocalString(@"btn_test")];
    btnTest.positionType = CCPositionTypeNormalized;
    btnTest.position = ccp(0.5, 0.4);
    [btnTest setTarget:self selector:@selector(clickTest)];
    [self addChild:btnTest];

    [[OALSimpleAudio sharedInstance] playBg:@"bgBGM.m4v" loop:YES];
    
    return self;
}

-(void)clickStart
{
    [[OALSimpleAudio sharedInstance] playEffect:@"button.wav"];
    
    NSDictionary *dictionary = [[[DataManager sharedDataManager] getRoleInitialDic] getDictionary];
    [[CCDirector sharedDirector] pushScene:[[SelectPeopleScene alloc] initWithInitialList:dictionary]];
    
    
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
    ProgressPanel *panel = [[ProgressPanel alloc] initWithFunction:ProgressLoad];
    [self addChild:panel];
    
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
//    CGStoryScene *storyScene = [[CGStoryScene alloc] initWithStoryId:@"2"];
//    [[CCDirector sharedDirector] pushScene:storyScene];
//    CannonSelectionPanel *frame = [[CannonSelectionPanel alloc] initWithCannonList:@[@(1),@(2),@(3),@(4),@(5),@(6)] currPower:1];
//    [self addChild:frame];
    
}


-(void)selectIndex:(int)index
{
    NSLog(@"select : %d", index);
}

@end
