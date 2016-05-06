//
//  ShopGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShopGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"
#import "ItemBrowsePanel.h"
#import "GameCityData.h"
#import "GameDataManager.h"


@implementation ShopGroupButton
{
    NSString *_cityNo;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    DefaultButton *btnBuy = [DefaultButton buttonWithTitle:getLocalString(@"shop_buy")];
    DefaultButton *btnSell = [DefaultButton buttonWithTitle:getLocalString(@"shop_sale")];
    DefaultButton *btnTask = [DefaultButton buttonWithTitle:getLocalString(@"shop_task")];
    DefaultButton *btnMail = [DefaultButton buttonWithTitle:getLocalString(@"shop_mail")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnBuy,btnSell,btnTask,btnMail, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        _cityNo = cityNo;
        [btnBuy setTarget:self selector:@selector(clickBuyBtn)];
        [btnSell setTarget:self selector:@selector(clickSaleBtn)];
        [btnTask setTarget:self selector:@selector(clickTaskBtn)];
        [btnMail setTarget:self selector:@selector(clickMailBtn)];
    }
    return self;
}

-(void)clickBuyBtn
{
    GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:_cityNo];
    ItemBrowsePanel *item = [[ItemBrowsePanel alloc] initWithItems:cityData.itemList panelType:ItemBrowsePanelTypeBuy];
    [self addChild:item];
}

-(void)clickSaleBtn
{
    
}

-(void)clickTaskBtn
{
    
}

-(void)clickMailBtn
{
    
}
@end
