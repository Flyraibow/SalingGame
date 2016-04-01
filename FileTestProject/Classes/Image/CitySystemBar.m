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

typedef enum : NSUInteger {
    Button_Sail_MAP = 1,
    Button_Diary,
    Button_Ship_Info,
    Button_Sailor_Info,
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
    if (index == Button_System) {
        SystemGroupButton *systemButtonGroup = [SystemGroupButton new];
        [self.scene addChild:systemButtonGroup];
    } else if(index == Button_Sailor_Info) {
        RolePanel *rolePanel = [[RolePanel alloc] init];
        [self.scene addChild:rolePanel];
        
    } else if(index == Button_Ship_Info) {
        
    } else if(index == Button_Diary) {
        
    } else if(index == Button_Sail_MAP) {
        SailScene *sailScene = [[SailScene alloc] initWithType:SailSceneTypeRead];
        [[CCDirector sharedDirector] pushScene:sailScene];
    }
}

@end
