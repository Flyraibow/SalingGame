//
//  SailorNumberPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 7/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SailorNumberPanel.h"
#import "SailorNumberUnit.h"
#import "DefaultButton.h"
#import "LocalString.h"

@interface SailorNumberPanel() <SailorNumberPanelDelegate>

@end

@implementation SailorNumberPanel
{
    int _freeSailorNumber;
    CCLabelTTF *_labFreeSailor;
    NSArray<SailorNumberUnit *> *_shipNumberUnitList;
    int _totalSailorNumber;
}

-(instancetype)initWithShipList:(NSArray *)shipList freeSailorNumber:(int)freeSailorNumber
{
    
    NSUInteger count = shipList.count;
    CGFloat scale = 0.65;
    SailorNumberUnit *unit0 = [[SailorNumberUnit alloc] initWithShipData:shipList[0]];
    CGFloat width = unit0.contentSize.width * scale+ 10;
    CGFloat height = unit0.contentSize.height * scale * count + 30;
    NSMutableArray<SailorNumberUnit *> *shipNumberUnitList;
    _totalSailorNumber = 0;
    if (self = [super initWithSize:CGSizeMake(width, height)]) {
        for (int i = 0; i < count; ++i) {
            SailorNumberUnit *unit = i == 0 ? unit0 : [[SailorNumberUnit alloc] initWithShipData:shipList[i]];
            unit.anchorPoint = ccp(0, 1);
            unit.positionType = CCPositionTypePoints;
            unit.position = ccp(5, height - i * unit0.contentSize.height  * scale - 5);
            unit.delegate = self;
            unit.scale = scale;
            _totalSailorNumber += unit.shipData.curSailorNum;
            [self.frame addChild:unit];
            [shipNumberUnitList addObject:unit];
        }
        _shipNumberUnitList = shipNumberUnitList;
        _freeSailorNumber = freeSailorNumber;
        
        CCLabelTTF *labFreeSailor = [[CCLabelTTF alloc] initWithString:getLocalString(@"lab_free_sailor_number") fontName:nil fontSize:12];
        labFreeSailor.positionType = CCPositionTypePoints;
        labFreeSailor.anchorPoint = ccp(0, 0);
        labFreeSailor.position = ccp(5, 5);
        [self.frame addChild:labFreeSailor];
        
        _labFreeSailor = [[CCLabelTTF alloc] initWithString:[@(_freeSailorNumber) stringValue] fontName:nil fontSize:12];
        _labFreeSailor.positionType = CCPositionTypePoints;
        _labFreeSailor.anchorPoint = ccp(0, 0);
        _labFreeSailor.position = ccp(labFreeSailor.position.x + labFreeSailor.contentSize.width + 5, 5);
        [self.frame addChild:_labFreeSailor];
        
        static const CGFloat buttonScale = 0.4;
        
        DefaultButton *btnClose = [DefaultButton buttonWithTitle:getLocalString(@"lab_cancel")];
        btnClose.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomRight);
        btnClose.anchorPoint = ccp(1, 0);
        btnClose.position = ccp(5, 5);
        btnClose.scale = buttonScale;
        [self.frame addChild:btnClose];
        [btnClose setTarget:self selector:@selector(clickCloseButton)];
        
        DefaultButton *btnSure = [DefaultButton buttonWithTitle:getLocalString(@"lab_sure")];
        btnSure.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomRight);
        btnSure.anchorPoint = ccp(1, 0);
        btnSure.position = ccp(btnClose.position.x + btnClose.contentSize.width * buttonScale + 1, 5);
        btnSure.scale = buttonScale;
        [self.frame addChild:btnSure];
        [btnSure setTarget:self selector:@selector(clickSureButton)];
        
        DefaultButton *btnFirstArrange = [DefaultButton buttonWithTitle:getLocalString(@"lab_sailor_arrange_first")];
        btnFirstArrange.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomRight);
        btnFirstArrange.anchorPoint = ccp(1, 0);
        btnFirstArrange.position = ccp(btnSure.position.x + btnSure.contentSize.width * buttonScale + 1, 5);
        btnFirstArrange.scale = buttonScale;
        [self.frame addChild:btnFirstArrange];
        [btnFirstArrange setTarget:self selector:@selector(clickFirstArrangeBtn)];
        
        DefaultButton *btnAverageArrange = [DefaultButton buttonWithTitle:getLocalString(@"lab_sailor_arrange_average")];
        btnAverageArrange.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomRight);
        btnAverageArrange.anchorPoint = ccp(1, 0);
        btnAverageArrange.position = ccp(btnFirstArrange.position.x + btnFirstArrange.contentSize.width * buttonScale + 1, 5);
        btnAverageArrange.scale = buttonScale;
        [self.frame addChild:btnAverageArrange];
        [btnAverageArrange setTarget:self selector:@selector(clickAverageArrangeBtn)];
        
        DefaultButton *btnMinimumArrange = [DefaultButton buttonWithTitle:getLocalString(@"lab_sailor_arrange_minimum")];
        btnMinimumArrange.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomRight);
        btnMinimumArrange.anchorPoint = ccp(1, 0);
        btnMinimumArrange.position = ccp(btnAverageArrange.position.x + btnAverageArrange.contentSize.width * buttonScale + 1, 5);
        btnMinimumArrange.scale = buttonScale;
        [self.frame addChild:btnMinimumArrange];
        [btnMinimumArrange setTarget:self selector:@selector(clickMinimumArrangeBtn)];
    }
    
    return self;
}

-(instancetype)initWithShipList:(NSArray *)shipList
{
    if (self = [self initWithShipList:shipList freeSailorNumber:0]) {
        
    }
    return self;
}

-(void)clickCloseButton
{
    [self removeFromParent];
}

-(int)getFreeSailorNumbers
{
    return _freeSailorNumber;
}

-(void)setSailorNumberFrom:(int)prevSailorNumber toSailorNumber:(int)toSailorNumber
{
    int difference = toSailorNumber - prevSailorNumber;
    assert(difference < _freeSailorNumber);
    _freeSailorNumber -= difference;
    _labFreeSailor.string = [@(_freeSailorNumber) stringValue];
}

-(void)clickFirstArrangeBtn
{
    SailorNumberUnit *firstUnit = _shipNumberUnitList[0];
    GameShipData *firstShip = firstUnit.shipData;
    if (_totalSailorNumber <= firstShip.minSailorNum) {
        [firstUnit setSailorNumber:_totalSailorNumber];
        for (int i = 1; i < _shipNumberUnitList.count; ++i) {
            [_shipNumberUnitList[i] setSailorNumber:0];
        }
    } else {
        [firstUnit setSailorNumber:firstShip.minSailorNum];
        int leftSailors = _totalSailorNumber - firstShip.minSailorNum;
        int minSailors = 0;
        int maxSailors = 0;
        for (int i = 1; i < _shipNumberUnitList.count; ++i) {
            SailorNumberUnit *unit = _shipNumberUnitList[i];
            minSailors += unit.shipData.minSailorNum;
            maxSailors += unit.shipData.maxSailorNum;
        }
        if (leftSailors <= minSailors) {
            CGFloat scale = 1.0 * leftSailors / minSailors;
            for (int i = 1; i < _shipNumberUnitList.count; ++i) {
                SailorNumberUnit *unit = _shipNumberUnitList[i];
                if (i == _shipNumberUnitList.count - 1) {
                    [unit setSailorNumber:leftSailors];
                } else {
                    int sailors = ceil(scale * unit.shipData.minSailorNum);
                    [unit setSailorNumber:sailors];
                    leftSailors -= sailors;
                }
            }
        } else if (leftSailors - minSailors < firstShip.maxSailorNum - firstShip.minSailorNum) {
            [firstUnit setSailorNumber:firstShip.minSailorNum + leftSailors - minSailors];
            for (int i = 1; i < _shipNumberUnitList.count; ++i) {
                SailorNumberUnit *unit = _shipNumberUnitList[i];
                [unit setSailorNumber:unit.shipData.minSailorNum];
            }
        } else if (leftSailors < maxSailors + firstShip.maxSailorNum - firstShip.minSailorNum) {
            [firstUnit setSailorNumber:firstShip.maxSailorNum];
            leftSailors -= firstShip.maxSailorNum + firstShip.minSailorNum;
            CGFloat scale = 1.0 * (leftSailors - minSailors) / (maxSailors - minSailors);
            for (int i = 1; i < _shipNumberUnitList.count; ++i) {
                SailorNumberUnit *unit = _shipNumberUnitList[i];
                if (i == _shipNumberUnitList.count - 1) {
                    [unit setSailorNumber:leftSailors];
                } else {
                    int sailors = ceil(scale * (unit.shipData.maxSailorNum - unit.shipData.minSailorNum)) + unit.shipData.minSailorNum;
                    [unit setSailorNumber:sailors];
                    leftSailors -= sailors;
                }
            }
        } else {
            for (int i = 0; i < _shipNumberUnitList.count; ++i) {
                SailorNumberUnit *unit = _shipNumberUnitList[i];
                [unit setSailorNumber:unit.shipData.maxSailorNum];
            }
        }
    }
    [self recalculateFreeSailor];
}

-(void)clickAverageArrangeBtn
{
    int leftSailors = _totalSailorNumber ;
    int minSailors = 0;
    int maxSailors = 0;
    for (int i = 0; i < _shipNumberUnitList.count; ++i) {
        SailorNumberUnit *unit = _shipNumberUnitList[i];
        minSailors += unit.shipData.minSailorNum;
        maxSailors += unit.shipData.maxSailorNum;
    }
    if (leftSailors <= minSailors) {
        CGFloat scale = 1.0 * leftSailors / minSailors;
        for (int i = 0; i < _shipNumberUnitList.count; ++i) {
            SailorNumberUnit *unit = _shipNumberUnitList[i];
            if (i == _shipNumberUnitList.count - 1) {
                [unit setSailorNumber:leftSailors];
            } else {
                int sailors = ceil(scale * unit.shipData.minSailorNum);
                [unit setSailorNumber:sailors];
                leftSailors -= sailors;
            }
        }
    } else if (leftSailors < maxSailors) {
        CGFloat scale = 1.0 * (leftSailors - minSailors) / (maxSailors - minSailors);
        for (int i = 0; i < _shipNumberUnitList.count; ++i) {
            SailorNumberUnit *unit = _shipNumberUnitList[i];
            if (i == _shipNumberUnitList.count - 1) {
                [unit setSailorNumber:leftSailors];
            } else {
                int sailors = ceil(scale * (unit.shipData.maxSailorNum - unit.shipData.minSailorNum)) + unit.shipData.minSailorNum;
                [unit setSailorNumber:sailors];
                leftSailors -= sailors;
            }
        }
    } else {
        for (int i = 0; i < _shipNumberUnitList.count; ++i) {
            SailorNumberUnit *unit = _shipNumberUnitList[i];
            [unit setSailorNumber:unit.shipData.maxSailorNum];
        }
    }
    [self recalculateFreeSailor];
}

-(void)clickMinimumArrangeBtn
{
    int leftSailors = _totalSailorNumber ;
    int minSailors = 0;
    for (int i = 0; i < _shipNumberUnitList.count; ++i) {
        SailorNumberUnit *unit = _shipNumberUnitList[i];
        minSailors += unit.shipData.minSailorNum;
    }
    if (leftSailors <= minSailors) {
        CGFloat scale = 1.0 * leftSailors / minSailors;
        for (int i = 0; i < _shipNumberUnitList.count; ++i) {
            SailorNumberUnit *unit = _shipNumberUnitList[i];
            if (i == _shipNumberUnitList.count - 1) {
                [unit setSailorNumber:leftSailors];
            } else {
                int sailors = ceil(scale * unit.shipData.minSailorNum);
                [unit setSailorNumber:sailors];
                leftSailors -= sailors;
            }
        }
    } else {
        for (int i = 0; i < _shipNumberUnitList.count; ++i) {
            SailorNumberUnit *unit = _shipNumberUnitList[i];
            [unit setSailorNumber:unit.shipData.minSailorNum];
        }
    }
    [self recalculateFreeSailor];
}

-(void)recalculateFreeSailor
{
    _freeSailorNumber = _totalSailorNumber;
    for (int i = 0; i < _shipNumberUnitList.count; ++i) {
        SailorNumberUnit *unit = _shipNumberUnitList[i];
        _freeSailorNumber -= unit.sailorNumber;
    }
    assert(_freeSailorNumber >= 0);
    _labFreeSailor.string = [@(_freeSailorNumber) stringValue];
}

-(void)clickSureButton
{
    
}

@end
