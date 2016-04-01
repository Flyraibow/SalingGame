//
//  GoodsIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GoodsIcon.h"
#import "LocalString.h"
#import "DataManager.h"


@implementation GoodsIcon
{
    CCSprite *_icon;
    CCLabelTTF *_labPrice;
    CCLabelTTF *_labLevel;
    BOOL _showNum;
    CCSprite *_spriteNum;
    CCLabelTTF *_labNum;
    CCLabelTTF *_labGoodsName;
    NSString *_iconNo;
}

@synthesize goodsId = _goodsId;

-(instancetype)init
{
    if (self = [super initWithImageNamed:@"goodsIconFrame.png"]) {
        _icon = [[CCSprite alloc] init];
        _icon.positionType = CCPositionTypePoints;
        _icon.anchorPoint = ccp(0 ,1);
        _icon.position = ccp(3,self.contentSize.height - 3);
        [self addChild:_icon];
        _labPrice = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:11];
        _labPrice.positionType = CCPositionTypePoints;
        _labPrice.anchorPoint = ccp(1 , 0);
        _labPrice.position = ccp(self.contentSize.width - 5, 18);
        [self addChild:_labPrice];
        _labLevel = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:11];
        _labLevel.positionType = CCPositionTypePoints;
        _labLevel.anchorPoint = ccp(1 , 0);
        _labLevel.position = ccp(self.contentSize.width - 5, 2);
        [self addChild:_labLevel];
        _labGoodsName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:11];
        _labGoodsName.positionType = CCPositionTypePoints;
        _labGoodsName.anchorPoint = ccp(1 , 0);
        _labGoodsName.position = ccp(self.contentSize.width - 5, 32);
        [self addChild:_labGoodsName];
        _showNum = NO;
        _number = -1;
    }
    return self;
}


-(void)setGoods:(NSString *)goodsId price:(int)price level:(int)level buyPrice:(int)buyPrice
{
    _goodsId = goodsId;
    _level = level;
    _price = price;
    _buyPrice = buyPrice;
    if (goodsId != nil) {
        GoodsData *goodsData = [[[DataManager sharedDataManager] getGoodsDic] getGoodsById:goodsId];
        if (![_iconNo isEqualToString:goodsData.iconId]) {
            _iconNo = goodsData.iconId;
            [_icon setSpriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"goods%@.jpg", _iconNo]]];
        }
        CCColor *blueColor = [CCColor colorWithRed:0.5 green:0.5 blue:1];
        if (_type == ShowNewBuyGoods) {
            _labGoodsName.color = blueColor;
            _labLevel.color = blueColor;
            _labPrice.color = blueColor;
            _labLevel.string = [NSString stringWithFormat:getLocalString(@"lab_goods_level"), level];
        } else {
            _labGoodsName.color = [CCColor whiteColor];
            if (_type == ShowBuyPrice) {
                _labLevel.color = blueColor;
                _labLevel.string = [@(buyPrice) stringValue];
            } else {
                _labLevel.color = [CCColor whiteColor];
                _labLevel.string = [NSString stringWithFormat:getLocalString(@"lab_goods_level"), level];
            }
            _labPrice.color = [CCColor whiteColor];
        }
        _labPrice.string = [@(price) stringValue];
        _labGoodsName.string = getGoodsName(goodsId);
        
        self.userInteractionEnabled = YES;
        _icon.visible = YES;
    } else {
        _labGoodsName.string = @"";
        _labLevel.string = @"";
        _labPrice.string = @"";
        _icon.visible = NO;
        self.userInteractionEnabled = NO;
    }
}


-(void)setNumber:(int)number
{
    if (_number != number) {
        if (!_showNum) {
            _spriteNum = [CCSprite spriteWithImageNamed:@"goodsIconNum.png"];
            _spriteNum.positionType = CCPositionTypePoints;
            _spriteNum.anchorPoint = ccp(1 , 0);
            _spriteNum.position = ccp(self.contentSize.width, 47);
            [self addChild:_spriteNum];
            
            _labNum = [CCLabelTTF labelWithString:[@(number) stringValue] fontName:nil fontSize:12];
            _labNum.anchorPoint = ccp(1, 0);
            _labNum.positionType = CCPositionTypePoints;
            _labNum.position = ccp(_spriteNum.contentSize.width - 2, 2);
            [_spriteNum addChild:_labNum];
        } else {
            _labNum.string = [@(number) stringValue];
        }
        _number = number;
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate selectGoodsIcon:self];
}

-(BOOL)isEmpty
{
    return _icon == nil || _icon.visible == NO;
}

@end
