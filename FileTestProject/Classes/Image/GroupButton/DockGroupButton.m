//
//  DockGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DockGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"
#import "SailScene.h"
#import "GameDataManager.h"
#import "GameTeamData.h"
#import "GamePanelManager.h"
#import "DataManager.h"

@implementation DockGroupButton
{
    NSString *_cityNo;
    int _cityStyle;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    DefaultButton *btnSail = [DefaultButton buttonWithTitle:getLocalString(@"dock_sail")];
    DefaultButton *btnSupply = [DefaultButton buttonWithTitle:getLocalString(@"dock_supply")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnSail, btnSupply, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
        _cityStyle = [[DataManager sharedDataManager].getCityDic getCityById:cityNo].cityStyle;
        [btnSail setTarget:self selector:@selector(clickSailBtn)];
        [btnSupply setTarget:self selector:@selector(clickSupplyBtn)];
    }
    return self;
}

-(void)clickSailBtn
{
    // Step 1: 补给食物（暂时不区分水和食物）
    MyGuild *myGuild = [GameDataManager sharedGameData].myGuild;
    GameTeamData *teamData = myGuild.myTeam;
    __block CGFloat needsFood = [teamData needsFoodCapacity];
    __block NSInteger money = needsFood * 100;
    
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelWithDelegate:nil];
    if (money > 0) {
        [dialogPanel setDefaultDialog:@"dialog_fill_food" arguments:@[@(money)] cityStyle:_cityStyle];
        [dialogPanel addYesNoWithCallback:^(int index) {
            if (index == 0) {
                if (myGuild.money < money) {
                    needsFood *= 1.0 * teamData.teamMoney / money;
                    money = teamData.teamMoney;
                }
                [myGuild spendMoney:money];
                [teamData fillFood:needsFood];
            }
            self.visible = YES;
            [self checkSailor:teamData];
        }];
        self.visible = NO;
        [self.scene addChild:dialogPanel];
    } else {
        [self checkSailor:teamData];
    }
}

-(void)checkSailor:(GameTeamData *)teamData
{
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelWithDelegate:nil];
    int sailorNumbers = [teamData sailorNumbers];
    if (sailorNumbers == 0) {
        // 如果某条船没有水手
        [dialogPanel setDefaultDialog:@"dialog_no_sailors" arguments:nil cityStyle:_cityStyle];
        [dialogPanel addConfirmHandler:^{
            self.visible = YES;
        }];
        self.visible = NO;
        if (dialogPanel.parent != self.scene) {
            [self.scene addChild:dialogPanel];
        }
    } else {
        //TODO: 检查水手是否充足，如果不足只是提醒，仍然可以继续上路
        if (sailorNumbers < 0) {
            sailorNumbers = - sailorNumbers;
            
            [dialogPanel setDefaultDialog:@"dialog_no_enough_sailors" arguments:nil cityStyle:_cityStyle];
            [dialogPanel addYesNoWithCallback:^(int index) {
                self.visible = YES;
                if (index == 0) {
                    // 继续前行
                    [self checkoutFood:teamData :sailorNumbers];
                }
            }];
            self.visible = NO;
            if (dialogPanel.parent != self.scene) {
                [self.scene addChild:dialogPanel];
            }
        } else {
            [self checkoutFood:teamData :sailorNumbers];
        }
    }
}

-(void)checkoutFood:(GameTeamData *)teamData :(int)sailorNumber
{
    CGFloat food = [teamData totalFood];
    int days = food * 200 / sailorNumber;
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelWithDelegate:nil];
    if (days >= 15) {
        [dialogPanel setDefaultDialog:@"dialog_checkout_food" arguments:@[@(days)] cityStyle:_cityStyle];
    } else {
        [dialogPanel setDefaultDialog:@"dialog_checkout_food_not_enough" arguments:@[@(days)] cityStyle:_cityStyle];
    }
    [dialogPanel addConfirmHandler:^{
        [self finalSail];
    }];
}

-(void)finalSail
{
    SailScene *sailScene = [[SailScene alloc] initWithType:SailSceneTypeGo];
    [[CCDirector sharedDirector] pushScene:sailScene];
}

-(void)clickSupplyBtn
{
    
}

-(void)showButton
{
    self.visible = YES;
}

@end
