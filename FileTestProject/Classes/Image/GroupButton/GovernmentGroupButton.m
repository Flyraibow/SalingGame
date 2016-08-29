//
//  GovernmentGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GovernmentGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "InvestPanel.h"
#import "BGImage.h"
#import "GameDataManager.h"
#import "CityBuildingGroup.h"
#import "DataManager.h"
#import "GamePanelManager.h"

@interface GovernmentGroupButton() <InvestPanelDelegate>

@end

@implementation GovernmentGroupButton
{
    NSString *_cityNo;
    int _cityStyle;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    NSMutableArray *arrayButton = [NSMutableArray new];
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
    if ([cityData.guildOccupation objectForKey:[GameDataManager sharedGameData].myGuild.guildId] == nil) {
        DefaultButton *btnSign = [DefaultButton buttonWithTitle:getLocalString(@"government_sign_up")];
        [arrayButton addObject:btnSign];
        [btnSign setTarget:self selector:@selector(clickSign)];
    }
    DefaultButton *btnInvest = [DefaultButton buttonWithTitle:getLocalString(@"government_invest")];
    [arrayButton addObject:btnInvest];
    DefaultButton *btnRecommend = [DefaultButton buttonWithTitle:getLocalString(@"government_recommend")];
    [arrayButton addObject:btnRecommend];
    if (self = [self initWithNSArray:arrayButton CCNodeColor:[BGImage getShadowForBackground]]) {
        _cityNo = cityNo;
        _cityStyle = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo].cityStyle;
        [btnInvest setTarget:self selector:@selector(clickInvest)];
        [btnRecommend setTarget:self selector:@selector(clickRecommend)];
    }
    return self;
}

-(void)clickSign
{
    if ([[[GameDataManager sharedGameData].cityDic objectForKey:_cityNo] canSignUp:[GameDataManager sharedGameData].myGuild.guildId]) {
        DialogPanel *dialog = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
        [dialog setDefaultDialog:@"dialog_signup_start" arguments:@[] cityStyle:_cityStyle];
        [dialog addConfirmHandler:^{
            InvestPanel *panel = [[InvestPanel alloc] initWithCityId:_cityNo investType:InvestTypeSignup];
            panel.delegate = self;
            [self.scene addChild:panel];
        }];
    } else {
        // Todo: 已经满了无法签约, 可能还有其他原因
        DialogPanel *dialog = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
        [dialog setDefaultDialog:@"dialog_signup_failure_full" arguments:@[] cityStyle:_cityStyle];
    }
}

-(void)investFailure
{
    // todo: we doesn't have the reason. Maybe one day, we will add the reason here.
    DialogPanel *dialog = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
    [dialog setDefaultDialog:@"dialog_no_enough_money" arguments:@[] cityStyle:_cityStyle];
}

-(void)investSucceed
{
    DialogPanel *dialog = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
    [dialog setDefaultDialog:@"dialog_invest_success" arguments:@[] cityStyle:_cityStyle];
}

-(void)clickInvest
{
    DialogPanel *dialog = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
    [dialog setDefaultDialog:@"dialog_military_invest_start" arguments:@[] cityStyle:_cityStyle];
    [dialog addConfirmHandler:^{
        InvestPanel *panel = [[InvestPanel alloc] initWithCityId:_cityNo investType:InvestTypeMilitary];
        panel.delegate = self;
        [self.scene addChild:panel];
    }];
}

-(void)clickRecommend
{
}

@end
