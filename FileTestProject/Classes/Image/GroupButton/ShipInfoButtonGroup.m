//
//  ShipInfoButtonGroup.m
//  FileTestProject
//
//  Created by FANXUEZHOU on 16/4/30.
//  Copyright © 2016年 Yujie Liu. All rights reserved.
//

#import "ShipInfoButtonGroup.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "ProgressScene.h"
#import "BGImage.h"
#import "RolePanel.h"

@implementation ShipInfoButtonGroup


-(instancetype)init
{
    DefaultButton *shipInfo = [DefaultButton buttonWithTitle:getLocalString(@"lab_ship_info")];
    DefaultButton *sailorInfo = [DefaultButton buttonWithTitle:getLocalString(@"lab_sailor_info")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:shipInfo,sailorInfo, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self)
    {
        [shipInfo setTarget:self selector:@selector(clickShipInfo)];
        [sailorInfo setTarget:self selector:@selector(clickSailorInfo)];
    }
    return self;
}

-(void)clickShipInfo
{
    NSLog(@"clickShipInfo");
}

-(void)clickSailorInfo
{
    NSLog(@"clickSailorInfo");
    RolePanel *rolePanel = [[RolePanel alloc] init];
    [self.scene addChild:rolePanel];

}


@end
