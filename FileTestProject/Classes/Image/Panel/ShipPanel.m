//
//  ShipPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 4/7/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipPanel.h"
#import "DataManager.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "ShipdeckIcon.h"
#import "GameDataManager.h"
#import "GameNPCData.h"
#import "RoleJobAnimation.h"
#import "RoleSelectionPanel.h"
#import "MoneyPanel.h"
#import "TimePanel.h"
#import "LabelPanel.h"
#import "TextInputPanel.h"
#import "CannonSelectionPanel.h"
#import "GamePanelManager.h"
#import "CannonData.h"
#import "GameValueManager.h"
#import "BGImage.h"

@interface ShipPanel()
< RoleSelectionPanelDelegate,
ShipdeckIconSelectProtocol,
TextInputPanelDelegate,
CannonSelectionPanelDelegate,
DateUpdateProtocol,
UpdateMoneyProtocol>

@end

@implementation ShipPanel
{
    __weak GameShipData *_shipData;
    CCSprite *_deckShipSprite;
    NSMutableArray *_roleAnimationList;
    NSMutableDictionary *_roomIconDict;
    CCButton *_btnRoleSelect;
    NSMutableArray *_unselectedNpcList;
    RoleSelectionPanel *_roleSelectionPanel;
    RoleJobAnimation *_selectedRole;
    MoneyPanel *_myMoneylPanel;
    MoneyPanel *_spendingMoneyPanel;
    TimePanel *_spendTimePanel;
    LabelPanel *_shipName;
    LabelPanel *_cannonName;
    CannonSelectionPanel *_cannonSelectionPanel;
    int _currentCannonId;
    BOOL _timing;
    CCTime _currentTime;
    NSArray *_cannonList;
    NSString *_cityNo;
    NSMutableDictionary *_originEquipDict;
    int _previousCannonRooms;
}

-(instancetype)initWithDataList:(NSArray *)dataList
{
    if (self = [super init]) {
        _shipData = [GameValueManager sharedValueManager].reservedShipData;
        _shipSceneType = [dataList[0] integerValue];
        
        [self addChild:[BGImage getBlackForBackground]];
        _deckShipSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Deckship%d.png", _shipData.shipStyleData.deckShipIcon]];
        _deckShipSprite.positionType = CCPositionTypeNormalized;
        _deckShipSprite.position = ccp(0.5, 0.5);
        _deckShipSprite.scale = self.contentSize.height / _deckShipSprite.contentSize.height;
        [self addChild:_deckShipSprite];
        
        _roomIconDict = [NSMutableDictionary new];
        _originEquipDict = [NSMutableDictionary new];
        _previousCannonRooms = _shipData.cannonRooms;
        NSArray *roomList = [_shipData.shipStyleData.roomList componentsSeparatedByString:@";"];
        for (int i = 0; i < roomList.count; ++i) {
            NSString *info = roomList[i];
            if (info.length > 0) {
                NSArray *infoList = [info componentsSeparatedByString:@"_"];
                int type = [infoList[0] intValue];
                int x = [infoList[1] intValue];
                int y = [infoList[2] intValue];
                int equipType =[_shipData.equipList[i] intValue];
                [_originEquipDict setObject:@(equipType) forKey:@(i)];
                ShipdeckIcon *shipdeckIcon = [[ShipdeckIcon alloc] initWithShipdeckType:type
                                                                              equipType:equipType
                                                                              sceneType:_shipSceneType];
                shipdeckIcon.shipData = _shipData;
                shipdeckIcon.positionType = CCPositionTypePoints;
                shipdeckIcon.anchorPoint = ccp(0, 0);
                shipdeckIcon.position = ccp(x, y);
                shipdeckIcon.delegate = self;
                if (type == ShipdeckTypeStorageRoom && equipType == StorageRoomTypeCannon) {
                    _previousCannonRooms++;
                }
                [_deckShipSprite addChild:shipdeckIcon];
                [_roomIconDict setObject:shipdeckIcon forKey:@(i)];
                shipdeckIcon.roomId = i;
            }
        }
        _currentTime = 0;
        _timing = NO;
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"btn_cancel")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(1, 0);
        btnClose.position = ccp(0.99,0);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [_deckShipSprite addChild:btnClose];
        
        if (_shipSceneType == DeckShipSceneDeck || _shipSceneType == DeckShipSceneModify) {
            DefaultButton *btnSure = [[DefaultButton alloc] initWithTitle:getLocalString(@"btn_sure")];
            btnSure.positionType = CCPositionTypeNormalized;
            btnSure.anchorPoint = ccp(1, 0);
            btnSure.position = ccp(0.99,0.05);
            [btnSure setTarget:self selector:@selector(clickBtnSure)];
            [_deckShipSprite addChild:btnSure];
        }
        if (_shipSceneType == DeckShipSceneModify) {
            _currentCannonId = _shipData.cannonId;
            _myMoneylPanel = [[MoneyPanel alloc] initWithText:getLocalString(@"lab_ship_modify_my_money")];
            _myMoneylPanel.anchorPoint = ccp(0, 0);
            _myMoneylPanel.positionType = CCPositionTypeNormalized;
            _myMoneylPanel.position = ccp(0.01, 0.01);
            [_myMoneylPanel setMoney:[GameDataManager sharedGameData].myGuild.money];
            [_deckShipSprite addChild:_myMoneylPanel];
            
            _spendingMoneyPanel = [[MoneyPanel alloc] initWithText:getLocalString(@"lab_ship_modify_spend_money")];
            _spendingMoneyPanel.anchorPoint = ccp(0, 0);
            _spendingMoneyPanel.positionType = CCPositionTypeNormalized;
            _spendingMoneyPanel.position = ccp(0.21, 0.01);
            [_deckShipSprite addChild:_spendingMoneyPanel];
            
            _spendTimePanel = [[TimePanel alloc] init];
            _spendTimePanel.anchorPoint = ccp(1, 0);
            _spendTimePanel.positionType = CCPositionTypeNormalized;
            _spendTimePanel.position = ccp(0.99, 0.13);
            [_deckShipSprite addChild:_spendTimePanel];
            
            _shipName = [[LabelPanel alloc] initWithFrameName:@"frame_label1.png"];
            _shipName.anchorPoint = ccp(0, 0);
            _shipName.positionType = CCPositionTypeNormalized;
            _shipName.position = ccp(0.42, 0.05);
            _shipName.label.string = _shipData.shipName;
            [_deckShipSprite addChild:_shipName];
            
            _cannonName = [[LabelPanel alloc] initWithFrameName:@"frame_label2.png"];
            _cannonName.anchorPoint = ccp(0, 0);
            _cannonName.positionType = CCPositionTypeNormalized;
            _cannonName.position = ccp(0.42, 0.01);
            _cannonName.label.string = getCannonName(_currentCannonId);
            [_deckShipSprite addChild:_cannonName];
            
            DefaultButton *btnChangeShipName = [DefaultButton buttonWithTitle:getLocalString(@"btn_ship_modify_change_name")];
            btnChangeShipName.anchorPoint = ccp(0, 0);
            btnChangeShipName.positionType = CCPositionTypeNormalized;
            btnChangeShipName.position = ccp(0.68, 0.05);
            [btnChangeShipName setTarget:self selector:@selector(clickChangeShipName)];
            [_deckShipSprite addChild:btnChangeShipName];
            
            
            DefaultButton *btnChangeCannon = [DefaultButton buttonWithTitle:getLocalString(@"btn_ship_modify_change_cannon")];
            btnChangeCannon.anchorPoint = ccp(0, 0);
            btnChangeCannon.positionType = CCPositionTypeNormalized;
            btnChangeCannon.position = ccp(0.68, 0.00);
            [btnChangeCannon setTarget:self selector:@selector(clickChangeCannon)];
            [_deckShipSprite addChild:btnChangeCannon];
            
            _cityNo = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
            [[GameDataManager sharedGameData].myGuild addMoneyUpdateClass:self];
            
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
    [self closePanelSuccess:NO];
}

- (void)closePanelSuccess:(BOOL)success
{
    [[GameDataManager sharedGameData].myGuild removeMoneyUpdateClass:self];
    [[GameDataManager sharedGameData] removeTimeUpdateClass:self];
    [self removeFromParent];
    if (success) {
        self.completionBlockWithEventId(self.successEvent);
    } else {
        self.completionBlockWithEventId(self.cancelEvent);
    }
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
        [self closePanelSuccess:YES];
    } else if (_shipSceneType == DeckShipSceneModify) {
        // wait days until the work is done
        if (_spendTimePanel.day == 0) {
            _shipData.shipName = _shipName.label.string;
            _shipData.cannonId = _currentCannonId;
            NSMutableArray *equipList = [_shipData.equipList mutableCopy];
            for (NSNumber *roomId in _roomIconDict) {
                ShipdeckIcon *icon = [_roomIconDict objectForKey:roomId];
                equipList[[roomId intValue]] = @(icon.equipType);
            }
            _shipData.equipList = equipList;
            [self closePanelSuccess:YES];
        } else {
            // 先加一个确认的对话框
            __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:nil];
            [dialogPanel setDefaultDialog:@"dialog_modify_ship_confirm" arguments:@[@(_spendingMoneyPanel.money), @(_spendTimePanel.day)]];
            [dialogPanel addYesNoWithCallback:^(int index) {
                if (index == 0) {
                    if ([GameDataManager sharedGameData].myGuild.money < _spendingMoneyPanel.money) {
                        // todo: maybe we need do some modify here
                        [dialogPanel setDefaultDialog:@"dialog_no_enough_money" arguments:nil];
                    } else {
                        [[GameDataManager sharedGameData] addTimeUpdateClass:self];
                        [[GameDataManager sharedGameData].myGuild spendMoney:_spendingMoneyPanel.money];
                        _timing = YES;
                        [[OALSimpleAudio sharedInstance] playEffect:@"carpenter.wav"];
                    }
                }
            }];
            [self addChild:dialogPanel];
            
        }
    }
}

-(void)update:(CCTime)delta
{
    if (_timing) {
        _currentTime += delta;
        if (_currentTime > 1.0) {
            _currentTime -= 1.0;
            [[GameDataManager sharedGameData] spendOneDay];
        }
    }
}

-(void)updateDate
{
    _spendTimePanel.day -= 1;
    if (_spendTimePanel.day == 0) {
        _timing = NO;
        [self clickBtnSure];
    } else {
        [self processDialog];
    }
}

-(void)processDialog
{
    NSMutableArray *dialogList = [GameDataManager sharedGameData].dialogList;
    if (dialogList.count > 0) {
        _timing = NO;
        GameDialogData *dialogData = [dialogList objectAtIndex:0];
        __weak DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:nil];
        __weak ShipPanel *weakSelf = self;
        [dialogPanel setDialogWithPhotoNo:dialogData.portrait npcName:dialogData.npcName text:dialogData.text handler:^{
            [weakSelf processDialog];
        }];
        [dialogList removeObjectAtIndex:0];
        if (dialogPanel.parent != self) {
            [self addChild:dialogPanel];
        }
    } else {
        _timing = YES;
    }
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

-(int)nextShipdeckEquipType:(id)shipdeckIcon
{
    ShipdeckIcon *shipdeck = shipdeckIcon;
    int equipType = shipdeck.equipType;
    if (shipdeck.shipDeckType == ShipdeckTypeFunctionRoom) {
        // 除了休息室可以建造多个，其他的房间最多一个
        NSMutableSet *functionRoomSet = [NSMutableSet new];
        for (NSNumber *roomId in _roomIconDict) {
            ShipdeckIcon *icon = [_roomIconDict objectForKey:roomId];
            if (icon.shipDeckType == ShipdeckTypeFunctionRoom && icon != shipdeck) {
                [functionRoomSet addObject:@(icon.equipType)];
            }
        }
        for (int i = (equipType + 1) % FunctionRoomEquipTypeCount; i != equipType; i = (i + 1) % FunctionRoomEquipTypeCount) {
            if (i == FunctionRoomEquipTypeLiving || ![functionRoomSet containsObject:@(i)]) {
                return i;
            }
        }
    } else if (shipdeck.shipDeckType == ShipdeckTypeStorageRoom) {
        int foodStorageNumber = 0;
        int goodsStorageNumber = 0;
        int cannonRoomNumber = 0;
        int sailorRoomNumber = 0;
        for (NSNumber *roomId in _roomIconDict) {
            ShipdeckIcon *icon = [_roomIconDict objectForKey:roomId];
            if (icon.shipDeckType == ShipdeckTypeStorageRoom && icon != shipdeck) {
                if (icon.equipType == StorageRoomTypeFood) {
                    foodStorageNumber++;
                } else if (icon.equipType == StorageRoomTypeGoods) {
                    goodsStorageNumber++;
                } else if (icon.equipType == StorageRoomTypeSailor) {
                    sailorRoomNumber++;
                } else if (icon.equipType == StorageRoomTypeCannon) {
                    cannonRoomNumber++;
                }
            }
        }
        if (foodStorageNumber <= 0) {
            return StorageRoomTypeFood;
        } else {
            for (int i = (equipType + 1) % StorageRoomTypeCount; i != equipType; i = (i + 1) % StorageRoomTypeCount) {
                if ((i == StorageRoomTypeGoods && goodsStorageNumber < 5) ||
                    (i == StorageRoomTypeSailor && sailorRoomNumber < 4) ||
                    (i == StorageRoomTypeCannon && cannonRoomNumber < 4) ||
                    (i == StorageRoomTypeNone && _shipData.equipList[shipdeck.roomId] == StorageRoomTypeNone) ||
                    (i == StorageRoomTypeFood)) {
                    return i;
                }
            }
        }
    }
    return equipType;
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
        //要确定能否交换，如果无法交换，则把当前的这个人放回待定区域
        if (roleAnimation) {
            if ([roleAnimation.npcData isableTodo:prevDeckIcon.job]) {
                prevDeckIcon.roleJobAnimation = roleAnimation;
            } else {
                [_unselectedNpcList addObject:roleAnimation.npcData];
                prevDeckIcon.roleJobAnimation = nil;
            }
        } else {
            prevDeckIcon.roleJobAnimation = roleAnimation;
        }
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

/////////改造船只/////////////////

-(void)clickChangeShipName
{
    TextInputPanel *textInputPanel = [[TextInputPanel alloc] initWithText:_shipName.label.string];
    textInputPanel.positionType = CCPositionTypeNormalized;
    textInputPanel.position = ccp(0.5, 0.5);
    textInputPanel.delegate = self;
    [self addChild:textInputPanel];
}

-(void)setText:(NSString *)text
{
    _shipName.label.string = text;
}

-(NSArray *)cannonList
{
    if (_cannonList == nil) {
        NSMutableArray *cannonList = [NSMutableArray new];
        GameCityData * cityData =[[GameDataManager sharedGameData].cityDic objectForKey:_cityNo];
        NSDictionary *cannonDic = [[[DataManager sharedDataManager] getCannonDic] getDictionary];
        for (NSString *cannonId in cannonDic) {
            CannonData *cannonData = [cannonDic objectForKey:cannonId];
            if (cannonData.milltaryValue <= cityData.milltaryValue) {
                [cannonList addObject:cannonData.cannonId];
            }
        }
        _cannonList = [cannonList sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]]];
    }
    return _cannonList;
}

-(void)clickChangeCannon
{
    if (_cannonSelectionPanel == nil) {
        _cannonSelectionPanel = [[CannonSelectionPanel alloc] initWithCannonList:[self cannonList] currCannonId:_currentCannonId];
        _cannonSelectionPanel.delegate = self;
    }
    [self addChild:_cannonSelectionPanel];
}

-(void)selectCannon:(int)cannonPower
{
    _currentCannonId = cannonPower;
    _cannonName.label.string = getCannonName(cannonPower);
    [self computeTimeAndMoney];
}

-(void)computeTimeAndMoney
{
    int totalTime = 0;
    int totolMoney = 0;
    
    BOOL functionRoomChanged = NO;
    BOOL storageRoomChanged = NO;
    int cannonRooms = 0;
    for (NSNumber *roomId in _roomIconDict) {
        ShipdeckIcon *icon = [_roomIconDict objectForKey:roomId];
        if (icon.shipDeckType == ShipdeckTypeFunctionRoom) {
            if (!functionRoomChanged && icon.equipType != [[_originEquipDict objectForKey:roomId] intValue]) {
                functionRoomChanged = YES;
                totalTime += 2;
            }
        } else if (icon.shipDeckType == ShipdeckTypeStorageRoom) {
            if (!storageRoomChanged && icon.equipType != [[_originEquipDict objectForKey:roomId] intValue]) {
                storageRoomChanged = YES;
                totalTime += 2;
            }
            if (icon.equipType == StorageRoomTypeCannon) {
                cannonRooms++;
            }
        }
    }
    int cannonNumber = _shipData.cannonNum + (cannonRooms - _previousCannonRooms) * 24;
    if (_shipData.cannonId!= _currentCannonId || cannonNumber != _shipData.cannonNum) {
        CannonDic *cannonDic = [[DataManager sharedDataManager] getCannonDic];
        CannonData *prevCannonData = [cannonDic getCannonById:[@(_shipData.cannonId) stringValue]];
        CannonData *currCannonData = [cannonDic getCannonById:[@(_currentCannonId) stringValue]];
        NSInteger previousPrice = prevCannonData.price * _shipData.cannonNum;
        NSInteger exchangePrice = 0;
        if (_shipData.cannonId!= _currentCannonId) {
            totalTime += 5;
            previousPrice /= 2;
            exchangePrice = currCannonData.price * cannonNumber;
        } else {
            exchangePrice = (cannonNumber - _shipData.cannonNum) * currCannonData.price;
            if (cannonNumber < _shipData.cannonNum) {
                exchangePrice /= 2;
            }
        }
        totolMoney += exchangePrice - previousPrice ;
    }
    
    [_spendingMoneyPanel setMoney:totolMoney];
    [_spendTimePanel setDay:totalTime];
}

-(void)shipDestroyed
{
    [self closePanelSuccess:YES];
}

-(void)updateMoney:(NSInteger)money
{
    _myMoneylPanel.money = money;
}


@end
