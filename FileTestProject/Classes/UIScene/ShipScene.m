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
#import "RoleSelectionPanel.h"

@interface ShipScene() < RoleSelectionPanelDelegate, ShipdeckIconSelectProtocol>

@end

@implementation ShipScene
{
    GameShipData *_shipData;
    CCSprite *_deckShipSprite;
    ShipStyleData *_shipStyleData;
    CGSize _viewSize;
    NSMutableArray *_roleAnimationList;
    NSMutableDictionary *_roomIconDict;
    CCButton *_btnRoleSelect;
    NSMutableArray *_unselectedNpcList;
    RoleSelectionPanel *_roleSelectionPanel;
    RoleJobAnimation *_selectedRole;
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
                shipdeckIcon.delegate = self;
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
        
        DefaultButton *btnSure = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_sure")];
        btnSure.positionType = CCPositionTypeNormalized;
        btnSure.anchorPoint = ccp(1, 0);
        btnSure.position = ccp(0.99,0.05);
        [btnSure setTarget:self selector:@selector(clickBtnSure)];
        [_deckShipSprite addChild:btnSure];
        // TODO： 如果是改造模式，显示当前资金，日期，改造累计费用, 确认
        if (_shipSceneType == DeckShipSceneModify) {
            
            btnClose.label.string = getLocalString(@"lab_cancel");
        } else if (_shipSceneType == DeckShipSceneDeck) {
            // TODO： 如果是甲板模式，分为两个小模式，都显示小人，其中一个可以随意调动小人的位置，另一个，用于查看小人状态。
            CCSpriteFrame *roleSelectUp = [CCSpriteFrame frameWithImageNamed:@"button_role_up.png"];
            CCSpriteFrame *roleSelectDown = [CCSpriteFrame frameWithImageNamed:@"button_role_down.png"];
            _btnRoleSelect = [CCButton buttonWithTitle:@"" spriteFrame:roleSelectUp highlightedSpriteFrame:roleSelectUp disabledSpriteFrame:roleSelectDown];
            _btnRoleSelect.anchorPoint = ccp(1, 1);
            _btnRoleSelect.positionType = CCPositionTypeNormalized;
            _btnRoleSelect.position = ccp(0.95, 0.95);
            [_btnRoleSelect setTarget:self selector:@selector(clickRoleSelectButton)];
            [_deckShipSprite addChild:_btnRoleSelect];
            _roleAnimationList = [NSMutableArray new];
            _unselectedNpcList = [NSMutableArray new];
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
                    if (shipIcon != nil && shipIcon.job == gameNPCData.job) {
                        [shipIcon setRoleJobAnimation:roleAnimation];
                        shipIcon.canSelect = YES;
                    }
                } else {
                    // 说明暂时有没有职业的角色
                    [_unselectedNpcList addObject:gameNPCData];
                }
            }
            if (_unselectedNpcList.count == 0) {
                _btnRoleSelect.enabled = NO;
            }
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
    if (_shipSceneType == DeckShipSceneDeck)
    {
        for (int i = 0; i < _roleAnimationList.count; ++i) {
            RoleJobAnimation *roleAnimation = _roleAnimationList[i];
            roleAnimation.npcData.roomId = roleAnimation.roomId;
            roleAnimation.npcData.job = roleAnimation.job;
        }
    }
    [self clickBtnClose];
}

-(void)clickRoleSelectButton
{
    if (_selectedRole) {
        // 把人物放进待定区
        [_unselectedNpcList addObject:_selectedRole.npcData];
        ShipdeckIcon *prevDeckIcon;
        if (_selectedRole.roomId) {
            prevDeckIcon = [_roomIconDict objectForKey:@(_selectedRole.roomId)];
            prevDeckIcon.roleJobAnimation = nil;
            prevDeckIcon.selected = NO;
        }
        [self limitSelectRoomToRole];
        _selectedRole = nil;
    } else {
        // 打开人物选择面板
        _roleSelectionPanel = [[RoleSelectionPanel alloc] initWithNPCList:_unselectedNpcList];
        _roleSelectionPanel.delegate = self;
        [self addChild:_roleSelectionPanel];
    }
}

-(void)selectRole:(NSString *)roleId
{
    for (int i = 0; i < _roleAnimationList.count; ++i) {
        RoleJobAnimation *roleJobAnimation = [_roleAnimationList objectAtIndex:i];
        if ([roleJobAnimation.npcData.npcId isEqualToString:roleId]) {
            _selectedRole = roleJobAnimation;
            [self removeChild:_roleSelectionPanel];
            _roleSelectionPanel = nil;
            [self setSelectableFor:roleJobAnimation];
            break;
        }
    }
}

-(void)setSelectableFor:(RoleJobAnimation *)roleJobAnimation
{
    for (NSNumber *roomId in _roomIconDict) {
        ShipdeckIcon *icon = [_roomIconDict objectForKey:roomId];
        icon.canSelect = [roleJobAnimation.npcData isableTodo:icon.job];
    }
}

-(void)selectShipdeckIcon:(id)shipdeckIcon
{
    ShipdeckIcon *deckIcon = (ShipdeckIcon *)shipdeckIcon;
    RoleJobAnimation *roleAnimation = [deckIcon roleJobAnimation];
    
    if (_selectedRole != nil) {
        // 原先选择的格子变为非selected
        ShipdeckIcon *prevDeckIcon;
        if (_selectedRole.roomId) {
            prevDeckIcon = [_roomIconDict objectForKey:@(_selectedRole.roomId)];
            prevDeckIcon.selected = NO;
        } else {
            // 如果原来是待定人员， 那么把待定人员中的他移除
            [_unselectedNpcList removeObject:_selectedRole.npcData];
        }
        //先把所选的放进这个格子里面
        deckIcon.roleJobAnimation = _selectedRole;
        prevDeckIcon.roleJobAnimation = roleAnimation;
        // 把可选的格子再次限制在有人的格子上
        [self limitSelectRoomToRole];
        if (roleAnimation) {
            _selectedRole = nil;
            return;
        }
    }
    if (roleAnimation != _selectedRole) {
        _selectedRole = roleAnimation;
        if (roleAnimation) {
            // 把其他相关的格子都变成可选,包括待定人员的格子
            _btnRoleSelect.enabled = YES;
            deckIcon.selected = YES;
            [self setSelectableFor:roleAnimation];
        }
    } else {
        _selectedRole = NO;
        deckIcon.selected = NO;
    }
}

-(void)limitSelectRoomToRole
{
    _btnRoleSelect.enabled = _unselectedNpcList.count;
    for (NSNumber *roomId in _roomIconDict) {
        ShipdeckIcon *icon = [_roomIconDict objectForKey:roomId];
        icon.canSelect = icon.roleJobAnimation != nil;
    }
}

@end
