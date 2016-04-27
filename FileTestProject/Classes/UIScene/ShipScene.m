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

@implementation ShipScene
{
    GameShipData *_shipData;
    CCSprite *_deckShipSprite;
    ShipStyleData *_shipStyleData;
    CGSize _viewSize;
    
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
        
        NSArray *roomList = [_shipStyleData.roomList componentsSeparatedByString:@";"];
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
                [_deckShipSprite addChild:shipdeckIcon];
            }
        }
        
        DefaultButton *btnClose = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_close")];
        btnClose.positionType = CCPositionTypeNormalized;
        btnClose.anchorPoint = ccp(1, 0);
        btnClose.position = ccp(0.99,0);
        [btnClose setTarget:self selector:@selector(clickBtnClose)];
        [_deckShipSprite addChild:btnClose];
        
        // TODO： 如果是改造模式，显示当前资金，日期，改造累计费用, 确认
        if (_shipSceneType == DeckShipSceneModify) {
            DefaultButton *btnSure = [[DefaultButton alloc] initWithTitle:getLocalString(@"lab_sure")];
            btnSure.positionType = CCPositionTypeNormalized;
            btnSure.anchorPoint = ccp(1, 0);
            btnSure.position = ccp(0.99,0.05);
            [btnSure setTarget:self selector:@selector(clickBtnSure)];
            [_deckShipSprite addChild:btnSure];
            btnClose.label.string = getLocalString(@"lab_cancel");
        }
        // TODO： 如果是甲板模式，显示小人，还可以自定义模式
    }
    return self;
}

-(void)clickBtnClose
{
    [[CCDirector sharedDirector] popScene];
}

-(void)clickBtnSure
{
    
}

@end
