//
//  ShipyardGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipyardGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"
#import "ShipExchangeScene.h"
#import "GameDataManager.h"
#import "CityBuildingGroup.h"
#import "GamePanelManager.h"
#import "DockYardScene.h"

@implementation ShipyardGroupButton
{
    NSString *_cityNo;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    DefaultButton *btnBuy = [DefaultButton buttonWithTitle:getLocalString(@"shipyard_buy")];
    DefaultButton *btnSell = [DefaultButton buttonWithTitle:getLocalString(@"shipyard_sell")];
    DefaultButton *btnModify = [DefaultButton buttonWithTitle:getLocalString(@"shipyard_modify")];
    DefaultButton *btnFix = [DefaultButton buttonWithTitle:getLocalString(@"shipyard_fix")];
    DefaultButton *btnDockYard = [DefaultButton buttonWithTitle:getLocalString(@"dock_yard")];
    self = [super initWithNSArray:@[btnBuy,btnSell,btnModify,btnFix, btnDockYard] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
        [btnBuy setTarget:self selector:@selector(clickBuyBtn)];
        [btnSell setTarget:self selector:@selector(clickSaleBtn)];
        [btnModify setTarget:self selector:@selector(clickModifyBtn)];
        [btnFix setTarget:self selector:@selector(clickFixBtn)];
        [btnDockYard setTarget:self selector:@selector(clickDockYard)];
    }
    return self;
}

-(void)clickBuyBtn
{
    // TODO: add restriction of ship numbers
    if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count >= 5) {
        // if there are more than 5 ships, give the hint that the new ship would be
        DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
        [dialogPanel setDefaultDialog:@"dialog_new_ship_into_dock" arguments:@[]];
        [dialogPanel addConfirmHandler:^{
            [[CCDirector sharedDirector] pushScene:[[ShipExchangeScene alloc] initWithCityNo:_cityNo]];
        }];
    } else {
        [[CCDirector sharedDirector] pushScene:[[ShipExchangeScene alloc] initWithCityNo:_cityNo]];
    }
}

-(void)clickSaleBtn
{
    if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count <= 1) {
        DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
        [dialogPanel setDefaultDialog:@"dialog_no_ship_to_sale" arguments:@[]];
    } else {
        NSMutableArray<GameShipData *> *shipList = [[GameDataManager sharedGameData].myGuild.myTeam.shipList mutableCopy];
        // 加上当前在船坞的船只
        [shipList addObjectsFromArray:[[GameDataManager sharedGameData].myGuild.myTeam getCarryShipListInCity:_cityNo]];
        [[CCDirector sharedDirector] pushScene:[[ShipExchangeScene alloc] initWithShipList:shipList sceneType:ShipSceneTypeSell]];
    }
}

-(void)clickModifyBtn
{
    if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count <= 0) {
        DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:self hidden:YES];
        [dialogPanel setDefaultDialog:@"dialog_no_ship_no_game" arguments:@[]];
    } else {
        
        NSMutableArray<GameShipData *> *shipList = [[GameDataManager sharedGameData].myGuild.myTeam.shipList mutableCopy];
        // 加上当前在船坞的船只
        [shipList addObjectsFromArray:[[GameDataManager sharedGameData].myGuild.myTeam getCarryShipListInCity:_cityNo]];
        [[CCDirector sharedDirector] pushScene:[[ShipExchangeScene alloc] initWithShipList:shipList sceneType:ShipSceneTypeModify]];
    }
}

-(void)clickFixBtn
{
    
}

-(void)clickDockYard
{
    GameTeamData *teamData = [GameDataManager sharedGameData].myGuild.myTeam;
    NSArray *shipList = [teamData getCarryShipListInCity:_cityNo];
    DockYardScene *yardScene = [[DockYardScene alloc] initWithTeam:teamData extraShipList:shipList];
    yardScene.cityId = _cityNo;
    [[CCDirector sharedDirector] pushScene:yardScene];
}

@end
