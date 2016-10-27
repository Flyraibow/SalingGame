//
//  ShipSailModel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipSailModel.h"
#import "GameDataManager.h"
#import "GameRouteData.h"
#import "GamePanelManager.h"

@implementation ShipSailModel
{
    CGPoint _beforePosition;
    CGPoint _originalPosition;
    double _offsetY;
    double _moveX;
    double _moveY;
    BOOL _up;
    CGPoint _direction;
    double _currentTime;
    double _totalTime;
    double _speed;
    double _time;
    SailType _sailType;
    NSArray *_cityList;
    NSArray *_routeList;
    NSInteger _currentCityIndex;
    NSInteger _currentPointIndex;
    BOOL _dialog;
    __weak GameTeamData *_teamData;
}

-(instancetype)initWithTeam:(GameTeamData *)teamData
{
    if (self = [self initWithImageNamed:@"ship.png"]) {
        _offsetY = 0;
        _up = YES;
        _speed = [teamData getTeamSpeed] * 3;
        _dialog = NO;
        _teamData = teamData;
    }
    return self;
}

-(void)update:(CCTime)delta
{
    if (!_dialog) {
        NSMutableArray *dialogArray = [GameDataManager sharedGameData].dialogList;
        if ([dialogArray count] > 0) {
            GameDialogData *dialogData = [dialogArray objectAtIndex:0];
            [dialogArray removeObjectAtIndex:0];
            _dialog = YES;
            DialogPanel *dialogPanel = [GamePanelManager sharedDialogPanelAboveSprite:nil];
            [dialogPanel setDialogWithPhotoNo:dialogData.portrait npcName:dialogData.npcName text:dialogData.text];
            [dialogPanel addConfirmHandler:^{
                _dialog = NO;
            }];
            [self.scene addChild:dialogPanel];
        } else {
            if (_up) {
                _offsetY+=0.3;
                if (_offsetY >= 5) {
                    _up = NO;
                }
            } else {
                _offsetY-=0.3;
                if (_offsetY <= 0) {
                    _up = YES;
                }
            }
            if (_currentTime < _totalTime) {
                _currentTime += delta;
                _time += delta;
                while (_time >= 1.0) {
                    _time -= 1;
                    [[GameDataManager sharedGameData] spendOneDay];
                }
                if (_currentTime >= _totalTime) {
                    _currentTime -= _totalTime;
                    [self gotoNextDirectionPoint];
                }
                _moveX = (_direction.x - _beforePosition.x) * _currentTime / _totalTime;
                _moveY = (_direction.y - _beforePosition.y) * _currentTime / _totalTime;
                self.position = ccp(_beforePosition.x + _moveX,_beforePosition.y + _moveY);
            } else {
                self.position = _originalPosition;
            }
        }
    }
}

-(void)setPosition:(CGPoint)position
{
    super.position = ccp(position.x,position.y + _offsetY);
    _originalPosition = position;
}

// citylist is the reverse order
-(void)setDirectionList:(NSArray *)cityList
{
    NSAssert(cityList.count >= 2, @"it can be less than two cities");
    _cityList = cityList;
    _currentCityIndex = cityList.count - 2;
    [self gotoNextDestinationCity];
}

-(void)gotoNextDestinationCity
{
    if (_currentCityIndex >= 0) {
        self.currentCityNo = [_cityList objectAtIndex:_currentCityIndex + 1];
        NSString *toCityId = [_cityList objectAtIndex:_currentCityIndex--];
        _routeList = [[[GameRouteData sharedRouteDictionary] objectForKey:_currentCityNo] objectForKey:toCityId];
        _currentPointIndex = 0;
        [self gotoNextDirectionPoint];
    } else {
        _totalTime = 0;
        _currentTime = 0;
        self.currentCityNo = [_cityList objectAtIndex:0];
        [self.delegate reachDestinationCity:[_cityList objectAtIndex:0]];
    }
    
}


-(BOOL)isMoving
{
    return (_currentTime < _totalTime);
}

-(void)gotoNextDirectionPoint
{
    if (_currentPointIndex >= _routeList.count - 1) {
        [self gotoNextDestinationCity];
        return;
    }
    RoutePoint *routePoint = [_routeList objectAtIndex:++_currentPointIndex];
    if (routePoint.type == RouteTypeSeaAreaChange) {
        RoutePoint *routePoint1 = [_routeList objectAtIndex:++_currentPointIndex];
        self.position = ccp(routePoint1.point.x, routePoint1.point.y);
        [self gotoNextDirectionPoint];
        [_delegate changeSeaArea:[@(routePoint.point.y) stringValue]];
        return;
    }
    CGPoint point = routePoint.point;
    _beforePosition = _originalPosition;
    _direction = point;
    double distance = sqrt((point.x - _originalPosition.x) * (point.x - _originalPosition.x) + (point.y - _originalPosition.y) * (point.y - _originalPosition.y));
    _totalTime = distance / _speed;
    self.position = point;
    
}

@end
