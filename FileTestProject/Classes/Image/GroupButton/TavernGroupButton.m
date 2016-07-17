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

@implementation TavernGroupButton
{
    NSString *_cityNo;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    DefaultButton *btnDrink = [DefaultButton buttonWithTitle:getLocalString(@"tavern_drink")];
    DefaultButton *btnBuyDrink = [DefaultButton buttonWithTitle:getLocalString(@"tavern_buy_drink")];
    DefaultButton *btnHire = [DefaultButton buttonWithTitle:getLocalString(@"tavern_hire")];
    DefaultButton *btnSpread = [DefaultButton buttonWithTitle:getLocalString(@"tavern_spread")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnDrink,btnBuyDrink,btnHire,btnSpread, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
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
    //选择雇佣水手
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:_cityNo];
    DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelWithDelegate:nil];
    int averageWage = 10 + cityData.commerceValue / 200 + arc4random() % 10; // 平均工资
    int sailorNumber = 10 + cityData.milltaryValue / 200 + arc4random() % 10; // 本次可以招募到的人数
    int money = averageWage * sailorNumber;
    [dialogPanel setDefaultDialog:@"dialog_hire_sailor_confirm" arguments:@[@(money)]];
    [dialogPanel addYesNoWithCallback:^(int index) {
        self.visible = YES;
        if (index == 1) {
            // 确认钱够， 扣钱，加水手，显示还缺多少人到必要和，还缺多少人到满，可以继续雇佣人
        }
    }];
    [self.scene addChild:dialogPanel];
    self.visible = NO;
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
