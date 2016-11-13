//
//  DockYardPanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 9/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DockYardPanel.h"
#import "GameShipData.h"
#import "BGImage.h"
#import "LocalString.h"
#import "DefaultButton.h"
#import "ShipSimpleInfoIcon.h"
#import "GameDataManager.h"

static const CGFloat kMovingTotalTime = 0.5;

@implementation DockYardPanel
{
    __weak GameTeamData *_teamData;
    NSMutableArray<ShipSimpleInfoIcon *> *_shipIconList;
    NSMutableArray<ShipSimpleInfoIcon *> *_shipTeamIconList;
    BOOL _selectable;
    int _cityShipStartIndex;
    CCButton *_btnUp;
    CCButton *_btnDown;
    BOOL _moving;
    CGFloat _currentTime;
    NSUInteger _teamShipCount;
}

-(instancetype)initWithDataList:(NSArray *)dataList
{
    if (self = [super init]) {
        _teamData =  [GameDataManager sharedGameData].myGuild.myTeam;
        NSArray *shipList = [_teamData getCarryShipListInCity:self.cityId];
        
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
        btnClose.position = ccp(0.7,0.05);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [self addChild:btnClose];
        
        DefaultButton *btnSure = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_sure")];
        btnSure.positionType = CCPositionTypeNormalized;
        btnSure.anchorPoint = ccp(0.5,0);
        btnSure.position = ccp(0.3,0.05);
        [btnSure setTarget:self selector:@selector(clickBtnSure)];
        [self addChild:btnSure];
        
        _shipTeamIconList = [NSMutableArray new];
        _cityShipStartIndex = 0;
        _teamShipCount = _teamData.shipList.count;
        _shipIconList = [NSMutableArray new];
        int i = 0;
        for (GameShipData *shipData in [_teamData shipDataList]) {
            ShipSimpleInfoIcon *shipIcon = [[ShipSimpleInfoIcon alloc] initWithShipData:shipData];
            shipIcon.inTeam = YES;
            shipIcon.index = i;
            [shipIcon setTarget:self selector:@selector(selectShipIcon:)];
            shipIcon.position = [self getIconPositionByIndex:i++ inTeam:shipIcon.inTeam];
            [_shipIconList addObject:shipIcon];
            [_shipTeamIconList addObject:shipIcon];
            [self addChild:shipIcon];
        }
        i = 0;
        for (GameShipData *shipData in shipList) {
            ShipSimpleInfoIcon *shipIcon = [[ShipSimpleInfoIcon alloc] initWithShipData:shipData];
            shipIcon.inTeam = NO;
            shipIcon.index = i;
            if (i >= 5) {
                shipIcon.opacity = 0;
            }
            [shipIcon setTarget:self selector:@selector(selectShipIcon:)];
            shipIcon.position = [self getIconPositionByIndex:i++ inTeam:shipIcon.inTeam];
            [_shipIconList addObject:shipIcon];
            [self addChild:shipIcon];
        }
        
        _btnUp = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"upArrowButton.png"]];
        _btnUp.positionType = CCPositionTypePoints;
        _btnUp.anchorPoint = ccp(0, 1);
        _btnUp.position = ccp(self.contentSize.width / 2 + 200, self.contentSize.height - 70);
        [_btnUp setTarget:self selector:@selector(clickUpButton)];
        _btnUp.enabled = NO;
        [self addChild:_btnUp];
        
        _btnDown = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"downArrowButton.png"]];
        _btnDown.positionType = CCPositionTypePoints;
        _btnDown.anchorPoint = ccp(0, 0);
        _btnDown.position = ccp(self.contentSize.width / 2 + 200, self.contentSize.height - 270);
        [_btnDown setTarget:self selector:@selector(clickDownButton)];
        [self addChild:_btnDown];
        
        if (i <= 5) {
            _btnDown.visible = NO;
            _btnUp.visible = NO;
        }
        
        _selectable = YES;
        _moving = NO;
    }
    return self;
}

-(CGPoint)getIconPositionByIndex:(int)index inTeam:(BOOL)inTeam
{
    if (inTeam) {
        return ccp(self.contentSize.width / 2 - 100 , self.contentSize.height - 70 - index * 40);
    } else {
        return ccp(self.contentSize.width / 2 + 100, self.contentSize.height - 70 - index * 40);
    }
}

-(void)clickBtnClose
{
    [self removeFromParent];
    self.completionBlockWithEventId(self.cancelEvent);
}

-(void)selectShipIcon:(ShipSimpleInfoIcon *)shipIcon
{
    if (_selectable) {
        _selectable = NO;
        if (shipIcon.inTeam) {
            if (_teamShipCount <= 1) {
                _selectable = YES;
                return;
            }
            // 将这条船放到船坞的首位
            int selectedIndex = shipIcon.index;
            _currentTime = 0;
            _moving = YES;
            _btnUp.enabled = NO;
            for (ShipSimpleInfoIcon *ship in _shipIconList) {
                if (!ship.inTeam) {
                    // 直接移到最顶部
                    _cityShipStartIndex = 0;
                    ship.currentPoint = ship.position;
                    ship.destinyPoint = [self getIconPositionByIndex:++ship.index inTeam:ship.inTeam];
                    if (ship.index > 4) {
                        ship.currentAlpha = ship.opacity;
                        ship.destinyAlpha = 0;
                    } else {
                        ship.currentAlpha = ship.opacity;
                        ship.destinyAlpha = 1;
                    }
                    
                } else {
                    if (ship != shipIcon) {
                        if (selectedIndex < ship.index) {
                            // move Up
                            ship.currentPoint = ship.position;
                            ship.destinyPoint = [self getIconPositionByIndex:--ship.index inTeam:ship.inTeam];
                        }
                    } else {
                        [_shipTeamIconList removeObject:shipIcon];
                        shipIcon.currentPoint = shipIcon.position;
                        shipIcon.inTeam = NO;
                        shipIcon.index = 0;
                        shipIcon.destinyPoint = [self getIconPositionByIndex:shipIcon.index inTeam:shipIcon.inTeam];
                    }
                    
                }
            }
            --_teamShipCount;
        } else {
            if (_teamShipCount >= 5) {
                // 舰队最多五条船
                _selectable = YES;
            } else {
                // 将这条船放到舰队的末尾
                int selectedIndex = shipIcon.index;
                _currentTime = 0;
                _moving = YES;
                for (ShipSimpleInfoIcon *ship in _shipIconList) {
                    if (!ship.inTeam) {
                        if (ship != shipIcon) {
                            if (ship.index > selectedIndex) {
                                ship.currentPoint = ship.position;
                                ship.destinyPoint = [self getIconPositionByIndex:--ship.index inTeam:ship.inTeam];
                                if (ship.index == _cityShipStartIndex + 4) {
                                    ship.currentAlpha = ship.opacity;
                                    ship.destinyAlpha = 1;
                                }
                            }
                        } else {
                            [_shipTeamIconList addObject:shipIcon];
                            shipIcon.currentPoint = shipIcon.position;
                            shipIcon.inTeam = YES;
                            shipIcon.index = (int)_teamShipCount++;
                            shipIcon.destinyPoint = [self getIconPositionByIndex:shipIcon.index inTeam:shipIcon.inTeam];
                        }
                    }
                }
            }
        }
        if (_shipIconList.count - _teamShipCount <= 5) {
            _btnDown.visible = NO;
            _btnUp.visible = NO;
        } else {
            _btnDown.visible = YES;
            _btnDown.enabled = YES;
            _btnUp.visible = YES;
            _btnUp.enabled = NO;
        }
    }
}

-(void)update:(CCTime)delta
{
    if (_moving) {
        _currentTime += delta;
        if (_currentTime > kMovingTotalTime) {
            _currentTime = kMovingTotalTime;
            _moving = NO;
            _selectable = YES;
            
        }
        CGFloat ratio = _currentTime / kMovingTotalTime;
        for (ShipSimpleInfoIcon *shipIcon in _shipIconList) {
            if (!CGPointEqualToPoint(shipIcon.currentPoint, shipIcon.destinyPoint)) {
                shipIcon.position = ccp(shipIcon.currentPoint.x + ratio * (shipIcon.destinyPoint.x - shipIcon.currentPoint.x)
                                        , shipIcon.currentPoint.y + ratio * (shipIcon.destinyPoint.y - shipIcon.currentPoint.y));
                if (shipIcon.currentAlpha != shipIcon.destinyAlpha) {
                    shipIcon.opacity = shipIcon.currentAlpha + ratio * (shipIcon.destinyAlpha - shipIcon.currentAlpha);
                }
                if (!_moving) {
                    shipIcon.currentPoint = shipIcon.destinyPoint;
                    shipIcon.currentAlpha = shipIcon.destinyAlpha;
                }
            }
        }
    }
}

-(void)clickUpButton
{
    if (_selectable) {
        _selectable = NO;
        _cityShipStartIndex -= 1;
        for (ShipSimpleInfoIcon *shipIcon in _shipIconList) {
            if (!shipIcon.inTeam) {
                if (shipIcon.index < _cityShipStartIndex + 5 && shipIcon.index >= _cityShipStartIndex) {
                    shipIcon.currentAlpha = shipIcon.opacity;
                    shipIcon.destinyAlpha = 1;
                } else {
                    shipIcon.currentAlpha = shipIcon.opacity;
                    shipIcon.destinyAlpha = 0;
                }
                shipIcon.currentPoint = shipIcon.position;
                shipIcon.destinyPoint = [self getIconPositionByIndex:shipIcon.index - _cityShipStartIndex inTeam:shipIcon.inTeam];
            }
        }
        _currentTime = 0;
        _moving = YES;
        _btnDown.enabled = YES;
        if (_cityShipStartIndex == 0) {
            _btnUp.enabled = NO;
        }
    }
}

-(void)clickDownButton
{
    if (_selectable) {
        _selectable = NO;
        _cityShipStartIndex += 1;
        for (ShipSimpleInfoIcon *shipIcon in _shipIconList) {
            if (!shipIcon.inTeam) {
                if (shipIcon.index < _cityShipStartIndex + 5 && shipIcon.index >= _cityShipStartIndex) {
                    shipIcon.currentAlpha = shipIcon.opacity;
                    shipIcon.destinyAlpha = 1;
                } else {
                    shipIcon.currentAlpha = shipIcon.opacity;
                    shipIcon.destinyAlpha = 0;
                }
                shipIcon.currentPoint = shipIcon.position;
                shipIcon.destinyPoint = [self getIconPositionByIndex:shipIcon.index - _cityShipStartIndex inTeam:shipIcon.inTeam];
            }
        }
        _currentTime = 0;
        _moving = YES;
        _btnUp.enabled = YES;
        if (_cityShipStartIndex + 5 >= _shipIconList.count - _teamShipCount) {
            _btnDown.enabled = NO;
        }
    }
}

-(void)clickBtnSure
{
    if (_selectable) {
        for (int i = 0; i < _shipTeamIconList.count; ++i) {
            ShipSimpleInfoIcon *shipIcon = _shipTeamIconList[i];
            GameShipData *shipData = shipIcon.shipData;
            if ([_teamData.shipList containsObject:shipData.shipId]) {
                [(NSMutableArray *)_teamData.shipList removeObject:shipData.shipId];
                [(NSMutableArray *)_teamData.shipList insertObject:shipData.shipId atIndex:i];
            } else {
                [(NSMutableArray *)_teamData.shipList insertObject:shipData.shipId atIndex:i];
                [(NSMutableArray *)_teamData.carryShipList removeObject:shipData.shipId];
                shipIcon.shipData.cityId = nil;
            }
        }
        for (NSInteger i = _teamData.shipList.count - 1; i >=  _shipTeamIconList.count; --i) {
            GameShipData *shipData = [[GameDataManager sharedGameData].shipDic objectForKey:_teamData.shipList[i]];
            [(NSMutableArray *)_teamData.shipList removeObjectAtIndex:i];
            [(NSMutableArray *)_teamData.carryShipList addObject:shipData.shipId];
            shipData.cityId = self.cityId;
        }
        // TODO: 把所有人的职业放到新船里
        [self removeFromParent];
        self.completionBlockWithEventId(self.successEvent);
    }
}

@end
