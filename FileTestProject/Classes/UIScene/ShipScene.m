//
//  ShipModifyScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/7/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipScene.h"
#import "DataManager.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "ShipdeckIcon.h"
#import "GameDataManager.h"
#import "GameNPCData.h"
#import "RoleJobAnimation.h"

@implementation ShipScene
{
    GameShipData *_shipData;
    CCSprite *_deckShipSprite;
    ShipStyleData *_shipStyleData;
    CGSize _viewSize;
    NSMutableArray *_roleAnimationList;
    NSMutableDictionary *_roomIconDict;
}

-(instancetype)initWithShipData:(GameShipData *)shipData shipSceneType:(DeckShipSceneType)shipSceneType
{
    if (self = [super init]) {
        _viewSize = [CCDirector sharedDirector].viewSize;
        _shipData = shipData;
        _shipSceneType = shipSceneType;
        _shipStyleData = [[[DataManager sharedDataManager] getShipStyleDic] getShipStyleById:[@(_shipData.shipData.style) stringValue]];
        _deckShipSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Deckship%d.png", _shipStyleData.deckShipIcon]];
        _deckShipSprite.positionType = CCPositionTypeNormalized;
        _deckShipSprite.position = ccp(0.5, 0.5);
        _deckShipSprite.scale = _viewSize.height / _deckShipSprite.contentSize.height;
        [self addChild:_deckShipSprite];
        
        _roomIconDict = [NSMutableDictionary new];
        NSArray *roomList = [_shipStyleData.roomList componentsSeparatedByString:@";"];
        int roomId = 1;
        for (int i = 0; i < roomList.count; ++i) {
            NSString *info = roomList[i];
            if (info.length > 0) {
                NSArray *infoList = [info componentsSeparatedByString:@"_"];
                int type = [infoList[0] intValue];
                int x = [infoList[1] intValue];
                int y = [infoList[2] intValue];
                int equipType =[_shipData.equipList[i] intValue];
                ShipdeckIcon *shipdeckIcon = [[ShipdeckIcon alloc] initWithShipdeckType:type
                                                                              equipType:equipType
                                                                              sceneType:shipSceneType];
                shipdeckIcon.positionType = CCPositionTypePoints;
                shipdeckIcon.anchorPoint = ccp(0, 0);
                shipdeckIcon.position = ccp(x, y);
                [_deckShipSprite addChild:shipdeckIcon];
                [_roomIconDict setObject:shipdeckIcon forKey:@(roomId)];
                shipdeckIcon.roomId = roomId++;
            }
        }
        
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(1, 0);
        btnClose.position = ccp(0.99,0);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [_deckShipSprite addChild:btnClose];
        
        // TODO： 如果是改造模式，显示当前资金，日期，改造累计费用, 确认
        if (_shipSceneType == DeckShipSceneModify) {
            DefaultButton *btnSure = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_sure")];
            btnSure.positionType = CCPositionTypeNormalized;
            btnSure.anchorPoint = ccp(1, 0);
            btnSure.position = ccp(0.99,0.05);
            [btnSure setTarget:self selector:@selector(clickBtnSure)];
            [_deckShipSprite addChild:btnSure];
            btnClose.label.string = getLocalString(@"lab_cancel");
        } else if (_shipSceneType == DeckShipSceneDeck) {
            // TODO： 如果是甲板模式，分为两个小模式，都显示小人，其中一个可以随意调动小人的位置，另一个，用于查看小人状态。
            _roleAnimationList = [NSMutableArray new];
            NSArray *npcList = [GameDataManager sharedGameData].myGuild.myTeam.npcList;
            for (int i = 0; i < npcList.count; ++i) {
                GameNPCData *gameNPCData = [npcList objectAtIndex:i];
                RoleJobAnimation *roleAnimation = [[RoleJobAnimation alloc] initWithRoleId:gameNPCData.npcId];
                roleAnimation.npcData = gameNPCData;
                roleAnimation.positionType = CCPositionTypeNormalized;
                roleAnimation.position = ccp(0.5, 0.4);
                [_roleAnimationList addObject:roleAnimation];
                if (gameNPCData.job != NPCJobTypeNone || gameNPCData.roomId) {
                    ShipdeckIcon *shipIcon;
                    if (gameNPCData.roomId > 0) {
                        shipIcon = [_roomIconDict objectForKey:@(gameNPCData.roomId)];
                    } else {
                        // 根据职业寻找到合适的房间
                        for (NSNumber *rmId in _roomIconDict) {
                            shipIcon = [_roomIconDict objectForKey:rmId];
                            if (shipIcon.job == gameNPCData.job && shipIcon.roleJobAnimation == nil) {
                                break;
                            }
                        }
                    }
                    [roleAnimation setJob:gameNPCData.job];
                    if (shipIcon != nil && shipIcon.job == gameNPCData.job) {
                        [shipIcon setRoleJobAnimation:roleAnimation];
                    }
                }
            }
            // 暂时先显示小人再说
        }
        
    }
    return self;
}

-(void)clickBtnClose
{
    [[CCDirector sharedDirector] popScene];
}

-(void)clickBtnSure
{
    
}

@end
