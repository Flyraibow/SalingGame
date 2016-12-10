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
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    DefaultButton *btnSail = [DefaultButton buttonWithTitle:getLocalString(@"dock_sail")];
    DefaultButton *btnSupply = [DefaultButton buttonWithTitle:getLocalString(@"dock_supply")];
    DefaultButton *btnDockYard = [DefaultButton buttonWithTitle:getLocalString(@"dock_yard")];
    self = [super initWithNSArray:@[btnSail, btnSupply, btnDockYard] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
        [btnSail setTarget:self selector:@selector(clickSailBtn)];
        [btnSupply setTarget:self selector:@selector(clickSupplyBtn)];
        [btnDockYard setTarget:self selector:@selector(clickDockYard)];
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
    
    if (money > 0) {
        __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
        [dialogPanel setDefaultDialog:@"dialog_fill_food" arguments:@[@(money)]];
        [dialogPanel addYesNoWithCallback:^(int index) {
            if (index == 0) {
                if (myGuild.money < money) {
                    needsFood *= 1.0 * teamData.teamMoney / money;
                    money = teamData.teamMoney;
                }
                [myGuild spendMoney:money];
                [teamData fillFood:needsFood];
            }
            [self checkSailor:teamData];
        }];
    } else {
        [self checkSailor:teamData];
    }
}

-(void)checkSailor:(GameTeamData *)teamData
{
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
    int sailorNumbers = [teamData sailorNumbers];
    if (sailorNumbers == 0) {
        // 如果某条船没有水手
        [dialogPanel setDefaultDialog:@"dialog_no_sailors" arguments:nil];
    } else {
        //TODO: 检查水手是否充足，如果不足只是提醒，仍然可以继续上路
        if (sailorNumbers < 0) {
            sailorNumbers = - sailorNumbers;
            [dialogPanel setDefaultDialog:@"dialog_no_enough_sailors" arguments:nil];
            [dialogPanel addYesNoWithCallback:^(int index) {
                if (index == 0) {
                    // 继续前行
                    [self checkoutFood:teamData :sailorNumbers];
                }
            }];
        } else {
            [self checkoutFood:teamData :sailorNumbers];
        }
    }
}

-(void)checkoutFood:(GameTeamData *)teamData :(int)sailorNumber
{
    CGFloat food = [teamData totalFood];
    int days = food * 200 / sailorNumber;
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
    if (days >= 15) {
        [dialogPanel setDefaultDialog:@"dialog_checkout_food" arguments:@[@(days)]];
    } else {
        [dialogPanel setDefaultDialog:@"dialog_checkout_food_not_enough" arguments:@[@(days)]];
    }
    [dialogPanel addConfirmHandler:^{
        [self finalSail];
    }];
}

-(void)finalSail
{
//    SailScene *sailScene = [[SailScene alloc] initWithType:SailSceneTypeGo];
//    [[CCDirector sharedDirector] pushScene:sailScene];
}

-(void)clickSupplyBtn
{
    
}

-(void)clickDockYard
{
//    GameTeamData *teamData = [GameDataManager sharedGameData].myGuild.myTeam;
//    NSArray *shipList = [teamData getCarryShipListInCity:_cityNo];
//    DockYardScene *yardScene = [[DockYardScene alloc] initWithTeam:teamData extraShipList:shipList];
//    yardScene.cityId = _cityNo;
//    [[CCDirector sharedDirector] pushScene:yardScene];
}

@end
