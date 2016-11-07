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
#import "SystemGroupButton.h"
#import "ProgressScene.h"
#import "GameDataManager.h"
#import "UpdateMoneyProtocol.h"
#import "SailScene.h"
#import "RolePanel.h"
#import "InfoButtonGroup.h"
#import "ShipScene.h"
#import "SailorNumberPanel.h"
#import "GamePanelManager.h"

typedef enum : NSUInteger {
    Button_Sail_MAP = 1,
    Button_Sailor_Number,
    Button_Deck,
    Button_Ship_Info,
    Button_System
} Button_Type;

@interface CitySystemBar() <UpdateMoneyProtocol>

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
        
        for(int i = 1; i <= 5; ++i) {
            DefaultButton *button1 = [DefaultButton buttonWithTitle:getLocalStringByInt(@"citySystemBar_",i)];
            button1.anchorPoint = ccp(0,0.5);
            button1.name = [NSString stringWithFormat:@"%d",i];
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
        
        [[GameDataManager sharedGameData].myGuild addMoneyUpdateClass:self];
    }
    return self;
}

-(void)updateMoney:(NSInteger)money
{
    _labMyMoney.string = [@([GameDataManager sharedGameData].myGuild.money) stringValue];
}

-(void)clickSystemButton:(DefaultButton *)button
{
    int index = [button.name intValue];
    if (index == Button_System)
    {
        SystemGroupButton *systemButtonGroup = [SystemGroupButton new];
        [self.scene addChild:systemButtonGroup];
    }
    else if(index == Button_Deck)
    {
        if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count > 0) {
            GameShipData *shipData = [[GameDataManager sharedGameData].shipDic objectForKey:[[GameDataManager sharedGameData].myGuild.myTeam.shipList objectAtIndex:0]];
            ShipScene *shipScene = [[ShipScene alloc] initWithShipData:shipData shipSceneType:DeckShipSceneDeck];
            [[CCDirector sharedDirector] pushScene:shipScene];
        }
    }
    else if(index == Button_Ship_Info)//资讯包含船只信息和船员信息
    {
        InfoButtonGroup *infoButtonGroup = [InfoButtonGroup new];
        [self.scene addChild:infoButtonGroup];
    }
    else if(index == Button_Sailor_Number)
    {
        
        NSArray *shipList = [[GameDataManager sharedGameData].myGuild.myTeam shipDataList];
        if (shipList.count > 0) {
            
            SailorNumberPanel *sailorNumberPanel = [[SailorNumberPanel alloc] initWithShipList:shipList freeSailorNumber:0 completeEventId:nil];
            [self.scene addChild:sailorNumberPanel];
        } else {
            [[GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES] setDefaultDialog:@"dialog_no_ship_no_game" arguments:nil];
        }
    }
    else if(index == Button_Sail_MAP)
    {
        SailScene *sailScene = [[SailScene alloc] initWithType:SailSceneTypeRead];
        [[CCDirector sharedDirector] pushScene:sailScene];
    }
}

@end
