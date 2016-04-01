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
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnBuy,btnSell,btnModify,btnFix, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
        [btnBuy setTarget:self selector:@selector(clickBuyBtn)];
        [btnSell setTarget:self selector:@selector(clickSaleBtn)];
        [btnModify setTarget:self selector:@selector(clickModifyBtn)];
        [btnFix setTarget:self selector:@selector(clickFixBtn)];
    }
    return self;
}

-(void)clickBuyBtn
{
    // TODO: add restriction of ship numbers
    if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count >= 5) {
        MyGuild *myGuild = [GameDataManager sharedGameData].myGuild ;
        [self.baseSprite showDialog:myGuild.leaderId text:getDialogText(@"1")];
    } else {
        [[CCDirector sharedDirector] pushScene:[[ShipExchangeScene alloc] initWithCityNo:_cityNo]];
    }
}

-(void)clickSaleBtn
{
    // TODO: add restriction of ship numbers
    if ([GameDataManager sharedGameData].myGuild.myTeam.shipList.count <= 1) {
        MyGuild *myGuild = [GameDataManager sharedGameData].myGuild ;
        [self.baseSprite showDialog:myGuild.leaderId text:getDialogText(@"2")];
    } else {
        [[CCDirector sharedDirector] pushScene:[[ShipExchangeScene alloc] initWithShipList:[GameDataManager sharedGameData].myGuild.myTeam.shipList]];
    }
}

-(void)clickModifyBtn
{
    
}

-(void)clickFixBtn
{
    
}


@end
