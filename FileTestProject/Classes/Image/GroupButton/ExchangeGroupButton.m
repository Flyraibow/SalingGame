//
//  ExchangeGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ExchangeGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "InvestPanel.h"
#import "BGImage.h"
#import "TradeScene.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "DataManager.h"
#import "CityBuildingGroup.h"
#import "SailScene.h"
#import "GamePanelManager.h"

@interface ExchangeGroupButton()

@end

@implementation ExchangeGroupButton
{
    NSString *_cityNo;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    DefaultButton *btnTrade = [DefaultButton buttonWithTitle:getLocalString(@"exchange_trade")];
    DefaultButton *btnInvest = [DefaultButton buttonWithTitle:getLocalString(@"exchange_invest")];
    DefaultButton *btnInformation = [DefaultButton buttonWithTitle:getLocalString(@"exchange_information")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnTrade,btnInvest,btnInformation, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
        [btnTrade setTarget:self selector:@selector(clickTradeBtn)];
        [btnInvest setTarget:self selector:@selector(clickInvestBtn)];
        [btnInformation setTarget:self selector:@selector(clickInfomationBtn)];
    }
    return self;
}

-(void)clickTradeBtn
{
    // 如果城市新产物需要的道具在手上，则触发剧情
    GameCityData *gameCityData = [[GameDataManager sharedGameData].cityDic objectForKey:_cityNo];
    MyGuild *myGuild = [GameDataManager sharedGameData].myGuild;
    CityData *cityData = [[[DataManager sharedDataManager] getCityDic] getCityById:_cityNo];
    for (NSString *itemId in gameCityData.unlockGoodsDict) {
        GameItemData * gameItemData = [[GameDataManager sharedGameData].itemDic objectForKey:itemId];
        if ([gameItemData.guildId isEqualToString:myGuild.guildId]) {
            __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
            [dialogPanel setDefaultDialog:@"dialog_new_item_discover" arguments:@[getItemName(itemId)] cityStyle:cityData.cityStyle];
            [dialogPanel addYesNoWithCallback:^(int index) {
                if (index == 0) {
                    [gameCityData unlockGoodsByItem:itemId];
                    [gameItemData unlockGoods];
                }
            }];
            return;
        }
    }
    if (gameCityData != nil) {
        int percentage = [[gameCityData.guildOccupation objectForKey:myGuild.guildId] intValue];
        if (percentage > 0) {
            [[CCDirector sharedDirector] pushScene:[[TradeScene alloc] initWithCityNo:_cityNo]];
        } else {
            DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
            [dialogPanel setDefaultDialog:@"dialog_need_to_sign_before_exchange" arguments:@[] cityStyle:cityData.cityStyle];
        }
    }
}

-(void)clickInvestBtn
{
    InvestPanel *panel = [[InvestPanel alloc] initWithCityId:_cityNo investType:InvestTypeCommerce];
    [self.scene addChild:panel];
}

-(void)clickInfomationBtn
{
    SailScene *sailScene = [[SailScene alloc] initWithType:SailSceneTypeTradeInfo];
    [[CCDirector sharedDirector] pushScene:sailScene];
}

@end
