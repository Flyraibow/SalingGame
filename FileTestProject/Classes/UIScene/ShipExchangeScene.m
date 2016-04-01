//
//  ShipExchange.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ShipExchangeScene.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "ShipExchangeUnit.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "DataManager.h"
#import "ShipData.h"
#import "GameCityData.h"
#import "GameShipData.h"
#import "NSSet+Sort.h"

@interface ShipExchangeScene() <ShipExchangeBuySuccessProtocol>

@end

@implementation ShipExchangeScene
{
    CCLabelTTF *_labTitle;
    int _index;
    int _number;
    CCSprite *_sprite;
    CCButton *_rightBtn;
    CCButton *_leftbtn;
    NSMutableArray *_array;
    BOOL _moving;
}


-(instancetype)init
{
    if (self = [super init]) {
        CCSprite *bg = [BGImage getBgImageByName:@"bg_System.png"];
        [self addChild:bg];
        
        _labTitle = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:20];
        _labTitle.positionType = CCPositionTypeNormalized;
        _labTitle.anchorPoint = ccp(0.5,1);
        _labTitle.position = ccp(0.5,0.9);
        [self addChild:_labTitle];
        
        _sprite = [CCSprite new];
        _sprite.contentSize = [CCDirector sharedDirector].viewSize;
        _sprite.positionType = CCPositionTypeNormalized;
        _sprite.position = ccp(0.5, 0.5);
        [self addChild:_sprite];
        
        _rightBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"rightArrowButton.png"]];
        _rightBtn.positionType = CCPositionTypeNormalized;
        _rightBtn.anchorPoint = ccp(1, 0.5);
        _rightBtn.position = ccp(0.95, 0.5);
        [_rightBtn setTarget:self selector:@selector(clickRightButton)];
        
        [self addChild:_rightBtn];
        
        
        _leftbtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leftArrowButton.png"]];
        _leftbtn.positionType = CCPositionTypeNormalized;
        _leftbtn.anchorPoint = ccp(0, 0.5);
        _leftbtn.position = ccp(0.05, 0.5);
        [_leftbtn setTarget:self selector:@selector(clickLeftButton)];
        [self addChild:_leftbtn];
        
        _leftbtn.enabled = NO;
        
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(0.5,0);
        btnClose.position = ccp(0.5,0.05);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [self addChild:btnClose];
        _moving = NO;
        
        _array = [NSMutableArray new];
    }
    return self;
}

-(instancetype)initWithShipList:(NSArray *)shipList
{
    if (self = [self init]) {
        
        _labTitle.string = getLocalString(@"shipyard_sell");
        
        for (NSUInteger i = 0; i < shipList.count; ++i) {
            GameShipData *shipData = [shipList objectAtIndex:i];
            ShipExchangeUnit *shipUnit = [[ShipExchangeUnit alloc] initWithGameShipData:shipData];
            shipUnit.positionType = CCPositionTypeNormalized;
            shipUnit.position = ccp(0.3 + _number * 0.4,0.48);
            shipUnit.delegate = self;
            _number++;
            if (_number > 2) {
                shipUnit.opacity = 0;
            }
            [_sprite addChild:shipUnit];
            [_array addObject:shipUnit];
        }
        
        if (_number <= 2) {
            _rightBtn.enabled = NO;
        } else {
            _rightBtn.enabled = YES;
        }
        
    }
    return self;
}

-(instancetype)initWithCityNo:(NSString *)cityNo
{
    if (self = [self init]) {
        
        _labTitle.string = getLocalString(@"shipyard_buy");
        
        GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:cityNo];
        NSDictionary *shipDic = [[DataManager sharedDataManager].getShipDic getDictionary];
        _number = 0;
        _index = 0;
        NSArray *shipList = [cityData.shipsSet sortByNumberAscending:YES];
        for (NSString *shipNo in shipList) {
            ShipData *shipData = [shipDic objectForKey:shipNo];
            if (shipData != nil) {
                ShipExchangeUnit *sprite1 = [[ShipExchangeUnit alloc] initWithShipData:shipData];
                sprite1.positionType = CCPositionTypeNormalized;
                sprite1.position = ccp(0.3 + _number * 0.4,0.48);
                sprite1.delegate = self;
                _number++;
                if (_number > 2) {
                    sprite1.opacity = 0;
                }
                [_sprite addChild:sprite1];
                [_array addObject:sprite1];
            }
        }
        if (_number <= 2) {
            _rightBtn.enabled = NO;
        } else {
            _rightBtn.enabled = YES;
        }
        
        
    }
    return self;
}

-(void)clickRightButton
{
    if (_index + 2 < _number) {
        if(++_index >= _number - 2) _rightBtn.enabled = NO;
        _leftbtn.enabled = YES;
        _moving = YES;
    }
}

-(void)clickLeftButton
{
    if (_index > 0) {
        if (--_index <= 0) _leftbtn.enabled = NO;
        _rightBtn.enabled = YES;
        _moving = YES;
    }
}

-(void)update:(CCTime)delta
{
    if (_moving) {
        double offset = 0.5 - _index * 0.4;
        double currentOffset = _sprite.position.x;
        if (fabs(currentOffset - offset) < 0.01) {
            _sprite.position = ccp(offset, 0.5);
            _moving = NO;
            for (int i = 0; i < _index; ++i) {
                CCSprite *sprite = [_array objectAtIndex:i];
                sprite.opacity = 0;
            }
            for (int i = _index; i < _index + 2; ++i) {
                CCSprite *sprite = [_array objectAtIndex:i];
                sprite.opacity = 1;
            }
            for (int i = _index + 2; i < _number; ++i) {
                CCSprite *sprite = [_array objectAtIndex:i];
                sprite.opacity = 0;
            }
        } else {
            double moveOffset = offset * 0.3 + currentOffset * 0.7 - currentOffset;
            if (fabs(moveOffset) < 0.01) {
                moveOffset =  moveOffset > 0 ? 0.01 : -0.01;
            }
            _sprite.position = ccp(currentOffset + moveOffset, 0.5);
            for (int i = 0; i < _array.count; ++i) {
                CCSprite *sprite = [_array objectAtIndex:i];
                double x = sprite.position.x + _sprite.position.x - 0.5;
                if (x <= 0 || x >= 1) {
                    sprite.opacity = 0;
                } else if (x < 0.3) {
                    sprite.opacity = x / 0.3;
                } else if (x < 0.7) {
                    sprite.opacity = 1;
                } else {
                    sprite.opacity = (1 - x) / 0.3;
                }
            }
        }
    }
}

-(void)clickBtnClose
{
    [[CCDirector sharedDirector] popScene];
}

-(void)ShipDealComplete
{
    [[CCDirector sharedDirector] popScene];
}

@end
