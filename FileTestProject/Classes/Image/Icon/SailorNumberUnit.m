//
//  SailorNumberUnit.m
//  FileTestProject
//
//  Created by LIU YUJIE on 7/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SailorNumberUnit.h"
#import "DefaultButton.h"
#import "LocalString.h"

@implementation SailorNumberUnit
{
    CCLabelTTF *_labMiniSailorNumber;
    CCLabelTTF *_labMaxiSailorNumber;
    CCLabelTTF *_labCurrSailorNumber;
    CCButton *_rightBtn;
    CCButton *_leftBtn;
    int _currentShipNumber;
}

- (instancetype)initWithShipData:(GameShipData *)shipData
{
    if (self = [super initWithImageNamed:@"sailorNumberFrame.png"]) {
        _shipData = shipData;
        _currentShipNumber = shipData.curSailorNum;
        CCSprite *shipIcon = [[CCSprite alloc] initWithImageNamed:shipData.shipIconImageName];
        shipIcon.positionType = CCPositionTypePoints;
        shipIcon.anchorPoint = ccp(0, 0);
        shipIcon.position = ccp(16, 8);
        [self addChild:shipIcon];
        
        CCLabelTTF *labShipName = [CCLabelTTF labelWithString:shipData.shipName fontName:nil fontSize:13];
        labShipName.positionType = CCPositionTypePoints;
        labShipName.anchorPoint = ccp(0, 0);
        labShipName.position = ccp(86, 40);
        [self addChild:labShipName];
        
        CCLabelTTF *labLeader = [CCLabelTTF labelWithString:getLocalString(@"lab_captain") fontName:nil fontSize:13];
        labLeader.positionType = CCPositionTypePoints;
        labLeader.anchorPoint = ccp(0, 0);
        labLeader.position = ccp(78, 15);
        [self addChild:labLeader];
        
        CCLabelTTF *labLeaderName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
        labLeaderName.positionType = CCPositionTypePoints;
        labLeaderName.anchorPoint = ccp(0, 0);
        labLeaderName.position = ccp(117, 15);
        [self addChild:labLeaderName];
        
        CCLabelTTF *labMiniSailor = [CCLabelTTF labelWithString:getLocalString(@"lab_minimum_sailor_number") fontName:nil fontSize:13];
        labMiniSailor.positionType = CCPositionTypePoints;
        labMiniSailor.anchorPoint = ccp(0, 0);
        labMiniSailor.position = ccp(232, 40);
        [self addChild:labMiniSailor];
        
        _labMiniSailorNumber = [CCLabelTTF labelWithString:[@(shipData.minSailorNum) stringValue] fontName:nil fontSize:13];
        _labMiniSailorNumber.positionType = CCPositionTypePoints;
        _labMiniSailorNumber.position = ccp(335, 48);
        [self addChild:_labMiniSailorNumber];
        
        _labMaxiSailorNumber = [CCLabelTTF labelWithString:[@(shipData.maxSailorNum) stringValue] fontName:nil fontSize:13];
        _labMaxiSailorNumber.positionType = CCPositionTypePoints;
        _labMaxiSailorNumber.position = ccp(330, 24);
        [self addChild:_labMaxiSailorNumber];
        
        _labCurrSailorNumber = [CCLabelTTF labelWithString:[@(shipData.curSailorNum) stringValue] fontName:nil fontSize:13];
        _labCurrSailorNumber.positionType = CCPositionTypePoints;
        _labCurrSailorNumber.position = ccp(264, 24);
        [self addChild:_labCurrSailorNumber];
        
        _rightBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"rightArrowButton.png"]];
        _rightBtn.positionType = CCPositionTypePoints;
        _rightBtn.position = ccp(421, 45);
        [_rightBtn setTarget:self selector:@selector(clickRightButton)];
        [self addChild:_rightBtn];
        
        _leftBtn = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"leftArrowButton.png"]];
        _leftBtn.positionType = CCPositionTypePoints;
        _leftBtn.position = ccp(382, 45);
        [_leftBtn setTarget:self selector:@selector(clickLeftButton)];
        [self addChild:_leftBtn];
        
        DefaultButton * btnSetZero = [DefaultButton buttonWithTitle:getLocalString(@"lab_set_zero")];
        btnSetZero.positionType = CCPositionTypePoints;
        btnSetZero.position = ccp(405, 22);
        [btnSetZero setTarget:self selector:@selector(clickSetZeroButton)];
        btnSetZero.scale = 0.5;
        [self addChild:btnSetZero];
        
        DefaultButton * btnSetMax = [DefaultButton buttonWithTitle:getLocalString(@"lab_set_maximum")];
        btnSetMax.positionType = CCPositionTypePoints;
        btnSetMax.position = ccp(470, 22);
        [btnSetMax setTarget:self selector:@selector(clickSetMaxButton)];
        btnSetMax.scale = 0.5;
        [self addChild:btnSetMax];
        
        DefaultButton * btnSetMin = [DefaultButton buttonWithTitle:getLocalString(@"lab_set_minimum")];
        btnSetMin.positionType = CCPositionTypePoints;
        btnSetMin.position = ccp(470, 45);
        [btnSetMin setTarget:self selector:@selector(clickSetMinButton)];
        btnSetMin.scale = 0.5;
        [self addChild:btnSetMin];
    }
    return self;
}

- (void)clickLeftButton
{
    if (_currentShipNumber > 0) {
        [self.delegate setSailorNumberFrom:_currentShipNumber toSailorNumber:_currentShipNumber-1];
        _labCurrSailorNumber.string = [@(--_currentShipNumber) stringValue];
    }
}

- (void)clickRightButton
{
    if (_currentShipNumber < _shipData.maxSailorNum && [self.delegate getFreeSailorNumbers] > 0) {
        [self.delegate setSailorNumberFrom:_currentShipNumber toSailorNumber:_currentShipNumber+1];
        _labCurrSailorNumber.string = [@(++_currentShipNumber) stringValue];
    }
}

- (void)clickSetZeroButton
{
    if (_currentShipNumber > 0) {
        [self.delegate setSailorNumberFrom:_currentShipNumber toSailorNumber:0];
        _labCurrSailorNumber.string = [@(_currentShipNumber = 0) stringValue];
    }
}

- (void)clickSetMaxButton
{
    if (_currentShipNumber < _shipData.maxSailorNum) {
        int freeSailorNumber = [self.delegate getFreeSailorNumbers];
        int sailorNumber = MIN(_currentShipNumber + freeSailorNumber, _shipData.maxSailorNum);
        [self.delegate setSailorNumberFrom:_currentShipNumber toSailorNumber:sailorNumber];
        _labCurrSailorNumber.string = [@(_currentShipNumber = sailorNumber) stringValue];
    }
}

- (void)clickSetMinButton
{
    if (_currentShipNumber != _shipData.minSailorNum) {
        int freeSailorNumber = [self.delegate getFreeSailorNumbers];
        int sailorNumber = MIN(_currentShipNumber + freeSailorNumber, _shipData.minSailorNum);
        [self.delegate setSailorNumberFrom:_currentShipNumber toSailorNumber:sailorNumber];
        _labCurrSailorNumber.string = [@(_currentShipNumber = sailorNumber) stringValue];
    }
}

-(void)setSailorNumber:(int)sailorNumber
{
    _labCurrSailorNumber.string = [@(_currentShipNumber = sailorNumber) stringValue];
}

-(int)sailorNumber
{
    return [_labCurrSailorNumber.string intValue];
}

@end
