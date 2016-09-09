//
//  DockYardScene.m
//  FileTestProject
//
//  Created by Yujie Liu on 9/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DockYardScene.h"
#import "GameShipData.h"
#import "BGImage.h"
#import "LocalString.h"
#import "DefaultButton.h"

@implementation DockYardScene
{
    __weak GameTeamData *_teamData;
    
    NSMutableArray<GameShipData *> *_shipList;
}

-(instancetype)initWithTeam:(GameTeamData *)team extraShipList:(NSArray<GameShipData *> *)shipList
{
    if (self = [super init]) {
        _teamData = team;
        _shipList = [shipList mutableCopy];
        
        CCSprite *bg = [BGImage getBgImageByName:@"bg_System.png"];
        [self addChild:bg];
        
        CCLabelTTF *labTitle = [CCLabelTTF labelWithString:getLocalString(@"dock_yard") fontName:nil fontSize:20];
        labTitle.positionType = CCPositionTypeNormalized;
        labTitle.anchorPoint = ccp(0.5,1);
        labTitle.position = ccp(0.5,0.9);
        [self addChild:labTitle];
        
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(0.5,0);
        btnClose.position = ccp(0.5,0.05);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [self addChild:btnClose];
    }
    return self;
}

-(void)clickBtnClose
{
    [[CCDirector sharedDirector] popScene];
}

@end
