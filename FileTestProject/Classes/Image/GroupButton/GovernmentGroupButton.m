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

typedef enum : NSUInteger {
    SelectionTypeNone,
    SelectionTypeSignUp,
    SelectionTypeSignUpFinish,
    SelectionTypeInvest,
    SelectionTypeInvestFinish,
    SelectionTypeFinish,
} SelectionType;

@interface GovernmentGroupButton() <InvestPanelDelegate>

@end

@implementation GovernmentGroupButton
{
    NSString *_cityNo;
    SelectionType _type;
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
        [btnInvest setTarget:self selector:@selector(clickInvest)];
        [btnRecommend setTarget:self selector:@selector(clickRecommend)];
    }
    return self;
}

-(void)clickSign
{
    if ([[[GameDataManager sharedGameData].cityDic objectForKey:_cityNo] canSignUp:[GameDataManager sharedGameData].myGuild.guildId]) {
        [self showDefaultText:getLocalString(@"dialog_signup")];
        _type = SelectionTypeSignUp;
    } else {
        // 已经满了无法签约
        [self showDefaultText:getLocalString(@"dialog_signup_failure")];
        _type = SelectionTypeNone;
    }
}

-(void)confirm
{
    if (_type == SelectionTypeSignUp) {
        _type = SelectionTypeNone;
        InvestPanel *panel = [[InvestPanel alloc] initWithCityId:_cityNo investType:InvestTypeSignup];
        panel.delegate = self;
        [self.scene addChild:panel];
    }
}

-(void)investFailure
{
    [self showDefaultText:getLocalString(@"dialog_invest_failure")];
}

-(void)investSucceed
{
    [self showDefaultText:getLocalString(@"dialog_invest_succeed")];
}

-(void)clickInvest
{
    InvestPanel *panel = [[InvestPanel alloc] initWithCityId:_cityNo investType:InvestTypeMilltary];
    [self.scene addChild:panel];
}

-(void)clickRecommend
{
}

@end
