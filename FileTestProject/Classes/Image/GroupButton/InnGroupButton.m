//
//  InnGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "InnGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "SpendMoneyProtocol.h"
#import "BGImage.h"
#import "BaseFrame.h"
#import "CityBuildingGroup.h"
#import "GamePanelManager.h"

static CGFloat const TIME_INTERVAL = 0.2f;

@interface InnGroupButton ()

@end

@implementation InnGroupButton
{
    int _sleepDays;
    CGFloat _currentTime;
    NSString *_cityNo;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    if (self = [self init]) {
        _cityNo = cityNo;
    }
    return self;
}

-(instancetype)init
{
    DefaultButton *btnSleepOneDay = [DefaultButton buttonWithTitle:getLocalString(@"inn_one_day")];
    DefaultButton *btnSleepTenDay = [DefaultButton buttonWithTitle:getLocalString(@"inn_ten_day")];
    DefaultButton *btnSleepThirtyDay = [DefaultButton buttonWithTitle:getLocalString(@"inn_thirty_day")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnSleepOneDay,btnSleepTenDay,btnSleepThirtyDay, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        [btnSleepOneDay setTarget:self selector:@selector(clickOneDayBtn)];
        [btnSleepTenDay setTarget:self selector:@selector(clickTenDayBtn)];
        [btnSleepThirtyDay setTarget:self selector:@selector(clickThirtyDayBtn)];
    }
    return self;
}

-(void)spendMoneyFail:(SpendMoneyType)type
{
}

-(void)spendMoneySucceed:(SpendMoneyType)type
{
    // disable everything and hide the scene
    switch (type) {
        case SpendMoneyTypeSleepOneDay:
            break;
        case SpendMoneyTypeSleepTenDay:
            _sleepDays = 10;
            _currentTime = TIME_INTERVAL;
            [self hideView];
            break;
        case SpendMoneyTypeSleepThirtyDay:
            _sleepDays = 30;
            _currentTime = TIME_INTERVAL;
            [self hideView];
            break;
        default:
            break;
    }
}

-(void)hideView
{
    self.hidden = YES;
    [self.baseSprite setHidden:YES];
}

-(void)showView
{
    self.hidden = NO;
    [self.baseSprite setHidden:NO];
}

-(void)update:(CCTime)delta
{
    if (_sleepDays > 0)
    {
        if (_currentTime > 0 && ![GamePanelManager isInDialog]) {
            _currentTime -= delta;
            if (_currentTime < 0) {
                [self spendOneDay];
            }
        }
    }
}

-(void)spendOneDay
{
    [[GameDataManager sharedGameData] spendOneDay];
    _sleepDays--;
    if (_sleepDays == 0) {
        [self showView];
    } else {
        _currentTime = TIME_INTERVAL;
    }
}

-(void)sleepMultipleDays:(int)day
{
    MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
    [myguild spendMoney:day succesHandler:^{
        _sleepDays = day;
        _currentTime = TIME_INTERVAL;
        [self hideView];
    } failHandle:^{
        // TODO: add dialog here
        CCLOG(@"not enough money");
    }];
}

-(void)clickOneDayBtn
{
    [self sleepMultipleDays:1];
}

-(void)clickTenDayBtn
{
    [self sleepMultipleDays:10];
}

-(void)clickThirtyDayBtn
{
    [self sleepMultipleDays:30];
}


@end
