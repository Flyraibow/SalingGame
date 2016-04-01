//
//  DockGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DockGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"
#import "SailScene.h"
#import "GameDataManager.h"
#import "GameTeamData.h"
@implementation DockGroupButton


-(instancetype)init
{
    DefaultButton *btnSail = [DefaultButton buttonWithTitle:getLocalString(@"dock_sail")];
    DefaultButton *btnSupply = [DefaultButton buttonWithTitle:getLocalString(@"dock_supply")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnSail, btnSupply, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        [btnSail setTarget:self selector:@selector(clickSailBtn)];
        [btnSupply setTarget:self selector:@selector(clickSupplyBtn)];
    }
    return self;
}

-(void)clickSailBtn
{
    //TODO: 检查水手是否充足，检查食物是否充足
//    CheckShipResult result = [[GameDataManager sharedGameData].myGuild.myTeam checkShips];
//    if (result == CheckShipResultSuccess) {
        SailScene *sailScene = [[SailScene alloc] initWithType:SailSceneTypeGo];
        [[CCDirector sharedDirector] pushScene:sailScene];
//    } else {
//        self.visible = NO;
//        MyGuild *myGuild = [GameDataManager sharedGameData].myGuild ;
//        switch (result) {
//            case CheckShipResultNoShips:
//                [self showDialog:myGuild.leaderId text:getDialogText(@"4")];
//                break;
//            default:
//                break;
//        }
//    }
}

-(void)clickSupplyBtn
{
    
}

-(void)showButton
{
    self.visible = YES;
}

@end
