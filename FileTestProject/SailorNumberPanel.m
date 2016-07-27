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
}

-(instancetype)initWithShipList:(NSArray *)shipList freeSailorNumber:(int)freeSailorNumber
{
    
    NSUInteger count = 5;
    CGFloat scale = 0.65;
    SailorNumberUnit *unit0 = [[SailorNumberUnit alloc] initWithShipData:shipList[0]];
    CGFloat width = unit0.contentSize.width * scale+ 10;
    CGFloat height = unit0.contentSize.height * scale * count + 30;
    if (self = [super initWithSize:CGSizeMake(width, height)]) {
        for (int i = 0; i < count; ++i) {
            SailorNumberUnit *unit = i == 0 ? unit0 : [[SailorNumberUnit alloc] initWithShipData:shipList[0]];
            unit.anchorPoint = ccp(0, 1);
            unit.positionType = CCPositionTypePoints;
            unit.position = ccp(5, height - i * unit0.contentSize.height  * scale - 5);
            unit.delegate = self;
            unit.scale = scale;
            [self.frame addChild:unit];
        }
        _freeSailorNumber = freeSailorNumber;
    }
    
    DefaultButton *btnClose = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
    btnClose.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomRight);
    btnClose.anchorPoint = ccp(1, 0);
    btnClose.position = ccp(5, 5);
    btnClose.scale = 0.4;
    [self.frame addChild:btnClose];
    [btnClose setTarget:self selector:@selector(clickCloseButton)];
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
    // TODO: 显示水手
}

@end
