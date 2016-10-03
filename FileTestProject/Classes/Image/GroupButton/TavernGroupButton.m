//
//  TavernGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "TavernGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"
#import "GamePanelManager.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "GamePanelManager.h"
#import "SailorNumberPanel.h"

@implementation TavernGroupButton
{
    NSString *_cityNo;
    int _cityStyle;
    int _currentHiringNum;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    if (self = [self init]) {
        _cityNo = cityNo;
        GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
        _cityStyle = cityData.cityData.cityStyle;
    }
    return self;
}

-(instancetype)init
{
    DefaultButton *btnDrink = [DefaultButton buttonWithTitle:getLocalString(@"tavern_drink")];
    DefaultButton *btnBuyDrink = [DefaultButton buttonWithTitle:getLocalString(@"tavern_buy_drink")];
    DefaultButton *btnHire = [DefaultButton buttonWithTitle:getLocalString(@"tavern_hire")];
    DefaultButton *btnSpread = [DefaultButton buttonWithTitle:getLocalString(@"tavern_spread")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnDrink,btnBuyDrink,btnHire,btnSpread, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        [btnDrink setTarget:self selector:@selector(clickDrinkBtn)];
        [btnBuyDrink setTarget:self selector:@selector(clickBuyDrinkBtn)];
        [btnHire setTarget:self selector:@selector(clickHireBtn)];
        [btnSpread setTarget:self selector:@selector(clickSpreadBtn)];
    }
    return self;
}

-(void)clickDrinkBtn
{
    
}

-(void)clickBuyDrinkBtn
{
    
}

-(void)clickHireBtn
{
    _currentHiringNum = 0;
    // 如果没有船则无法招募水手
    if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count > 0) {
        [self _hireSailor:YES];
    } else {
        [[GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES] setDefaultDialog:@"dialog_no_ship_no_game" arguments:nil];
    }
}

-(void)_hireSailor:(BOOL)firstTime
{
    //选择雇佣水手
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:_cityNo];
    __block int needSailorNumbers = [[GameDataManager sharedGameData].myGuild.myTeam needSailorNumbersWithNewHiring:_currentHiringNum];
    
    __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
    if (needSailorNumbers == 0) {
        // 不需要雇佣水手了
        [dialogPanel setDefaultDialog:@"dialog_hire_full" arguments:nil cityStyle:_cityStyle];
        [dialogPanel addConfirmHandler:^{
            [self openArrangeSailorPanel:dialogPanel];
        }];
    } else {
        int averageWage = 10 + cityData.commerceValue / 200 + arc4random() % 10; // 平均工资
        __block int sailorNumber = 10 + cityData.milltaryValue / 200 + arc4random() % 10; // 本次可以招募到的人数
        int money = averageWage * sailorNumber;
        
        if ([GameDataManager sharedGameData].myGuild.money < money) {
            [dialogPanel setDefaultDialog:@"dialog_hire_sailor_no_money" arguments:@[@(money)] cityStyle:_cityStyle];
            [dialogPanel addConfirmHandler:^{
                [self openArrangeSailorPanel:dialogPanel];
            }];
        } else {
            // 如果是第一次，则只显示需要的钱，后面则显示还差的人口
            if (firstTime) {
                [dialogPanel setDefaultDialog:@"dialog_hire_sailor_confirm" arguments:@[@(money)] cityStyle:_cityStyle];
            } else {
                if (needSailorNumbers > 0) {
                    [dialogPanel setDefaultDialog:@"dialog_hire_continue_full" arguments:@[@(needSailorNumbers)] cityStyle:_cityStyle];
                } else if (needSailorNumbers < 0) {
                    [dialogPanel setDefaultDialog:@"dialog_hire_continue_need" arguments:@[@(-needSailorNumbers)] cityStyle:_cityStyle];
                }
            }
            [dialogPanel addYesNoWithCallback:^(int index) {
                if (index == 0) {
                    // 扣钱，加水手，显示还缺多少人到必要和，还缺多少人到满，可以继续雇佣人
                    [[GameDataManager sharedGameData].myGuild spendMoney:money];
                    _currentHiringNum += sailorNumber;
                    dialogPanel.canShowCoverPanel = NO;
                    [[GameDataManager sharedGameData] spendOneDayWithInterval:1.0 callback:^{
                        [dialogPanel setDefaultDialog:@"dialog_hire_sailor_success" arguments:@[@(money), @(sailorNumber)] cityStyle:_cityStyle];
                        [dialogPanel addConfirmHandler:^{
                            [self _hireSailor:NO];
                        }];
                    }];
                } else {
                    [self openArrangeSailorPanel:dialogPanel];
                }
            }];
        }
    }
}

-(void)openArrangeSailorPanel:(DialogPanel *)dialogPanel
{
    if (_currentHiringNum > 0) {
        dialogPanel.canShowCoverPanel = NO;
        SailorNumberPanel *sailorNumberPanel = [[SailorNumberPanel alloc]
                                                initWithShipList:[[GameDataManager sharedGameData].myGuild.myTeam shipDataList]
                                                freeSailorNumber:_currentHiringNum];
        sailorNumberPanel.hiddenPanel = self;
        [self.scene addChild:sailorNumberPanel];
    }
}

-(void)clickSpreadBtn
{
    // 散布谣言
    
}

-(void)clickCloseButton
{
    [super clickCloseButton];
    // 把当前的状态还原
}

@end
