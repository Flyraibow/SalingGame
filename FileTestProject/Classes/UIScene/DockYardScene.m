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
#import "ShipSimpleInfoIcon.h"

static const CGFloat kMovingTotalTime = 1.0;

@implementation DockYardScene
{
    __weak GameTeamData *_teamData;
    NSMutableArray<GameShipData *> *_shipList;
    NSMutableArray *_shipIconList;
    CGSize _sceneSize;
    BOOL _selectable;
    int _cityShipStartIndex;
    CCButton *_btnUp;
    CCButton *_btnDown;
    BOOL _moving;
    CGFloat _currentTime;
    NSUInteger _teamShipCount;
}

-(instancetype)initWithTeam:(GameTeamData *)team extraShipList:(NSArray<GameShipData *> *)shipList
{
    if (self = [super init]) {
        
        _sceneSize = [CCDirector sharedDirector].viewSize;
        
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
        
        _cityShipStartIndex = 0;
        _teamShipCount = team.shipList.count;
        _shipIconList = [NSMutableArray new];
        int i = 0;
        for (GameShipData *shipData in team.shipList) {
            ShipSimpleInfoIcon *shipIcon = [[ShipSimpleInfoIcon alloc] initWithShipData:shipData];
            shipIcon.inTeam = YES;
            shipIcon.index = i;
            [shipIcon setTarget:self selector:@selector(selectShipIcon:)];
            shipIcon.position = [self getIconPositionByIndex:i++ inTeam:shipIcon.inTeam];
            [_shipIconList addObject:shipIcon];
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
        _btnUp.position = ccp(_sceneSize.width / 2 + 200, _sceneSize.height - 70);
        [_btnUp setTarget:self selector:@selector(clickUpButton)];
        _btnUp.enabled = NO;
        [self addChild:_btnUp];
        
        _btnDown = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"downArrowButton.png"]];
        _btnDown.positionType = CCPositionTypePoints;
        _btnDown.anchorPoint = ccp(0, 0);
        _btnDown.position = ccp(_sceneSize.width / 2 + 200, _sceneSize.height - 270);
        [_btnDown setTarget:self selector:@selector(clickDownButton)];
        [self addChild:_btnDown];
        
        if (i < 5) {
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
        return ccp(_sceneSize.width / 2 - 100 , _sceneSize.height - 70 - index * 40);
    } else {
        return ccp(_sceneSize.width / 2 + 100, _sceneSize.height - 70 - index * 40);
    }
}

-(void)clickBtnClose
{
    [[CCDirector sharedDirector] popScene];
}

-(void)selectShipIcon:(ShipSimpleInfoIcon *)shipIcon
{
    if (_selectable) {
        _selectable = NO;
        if (shipIcon.inTeam) {
            // 将这条船放到船坞的首位
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
                            shipIcon.currentPoint = shipIcon.position;
                            shipIcon.inTeam = YES;
                            shipIcon.index = (int)_teamShipCount++;
                            shipIcon.destinyPoint = [self getIconPositionByIndex:shipIcon.index inTeam:shipIcon.inTeam];
                        }
                    }
                    
                }
            }
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
        if (_cityShipStartIndex + 5 == _shipList.count - _teamShipCount) {
            _btnDown.enabled = NO;
        }
    }
}

@end
