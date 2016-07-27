//
//  SailorNumberUnit.m
//  FileTestProject
//
//  Created by LIU YUJIE on 7/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SailorNumberUnit.h"
#import "DefaultButton.h"

@implementation SailorNumberUnit
{
    CCLabelTTF *_labMiniSailorNumber;
    CCLabelTTF *_labMaxiSailorNumber;
    CCLabelTTF *_labCurriSailorNumber;
    CCButton *_rightBtn;
    CCButton *_leftBtn;
}

- (instancetype)initWithShipData:(GameShipData *)shipData
{
    if (self = [super initWithImageNamed:@"sailorNumberFrame.png"]) {
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
        
        CCLabelTTF *labLeader = [CCLabelTTF labelWithString:@"舰长" fontName:nil fontSize:13];
        labLeader.positionType = CCPositionTypePoints;
        labLeader.anchorPoint = ccp(0, 0);
        labLeader.position = ccp(78, 15);
        [self addChild:labLeader];
        
        CCLabelTTF *labLeaderName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:13];
        labLeaderName.positionType = CCPositionTypePoints;
        labLeaderName.anchorPoint = ccp(0, 0);
        labLeaderName.position = ccp(117, 15);
        [self addChild:labLeaderName];
        
        CCLabelTTF *labMiniSailor = [CCLabelTTF labelWithString:@"必要水手数：" fontName:nil fontSize:13];
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
        
        _labCurriSailorNumber = [CCLabelTTF labelWithString:[@(shipData.curSailorNum) stringValue] fontName:nil fontSize:13];
        _labCurriSailorNumber.positionType = CCPositionTypePoints;
        _labCurriSailorNumber.position = ccp(264, 24);
        [self addChild:_labCurriSailorNumber];
        
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
        
        DefaultButton * btnSetZero = [DefaultButton buttonWithTitle:@"设为0"];
        btnSetZero.positionType = CCPositionTypePoints;
        btnSetZero.position = ccp(405, 22);
        [btnSetZero setTarget:self selector:@selector(clickSetZeroButton)];
        btnSetZero.scale = 0.5;
        [self addChild:btnSetZero];
        
        DefaultButton * btnSetMax = [DefaultButton buttonWithTitle:@"设为最大值"];
        btnSetMax.positionType = CCPositionTypePoints;
        btnSetMax.position = ccp(470, 22);
        [btnSetMax setTarget:self selector:@selector(clickSetMaxButton)];
        btnSetMax.scale = 0.5;
        [self addChild:btnSetMax];
        
        DefaultButton * btnSetMin = [DefaultButton buttonWithTitle:@"设为必要值"];
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
    
}

- (void)clickRightButton
{
    
}

- (void)clickSetZeroButton
{
    
}

- (void)clickSetMaxButton
{
    
}

- (void)clickSetMinButton
{
    
}

@end
