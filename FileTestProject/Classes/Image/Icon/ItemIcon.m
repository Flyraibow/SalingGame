//
//  ItemIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ItemIcon.h"
#import "ItemData.h"

@implementation ItemIcon
{
    CCSprite *_itemSprite;
    BOOL _useFrame;
}

-(instancetype)init
{
    if (self = [super initWithImageNamed:@"shipIconFrame.png"]) {
        self.userInteractionEnabled = YES;
        _useFrame = YES;
    }
    return self;
}

-(void)setItemData:(GameItemData *)gameItemData
{
    if (gameItemData) {
        ItemData *itemData = gameItemData.itemData;
        if (![itemData.iconId isEqualToString:_itemData.itemData.iconId]) {
            [_itemSprite removeFromParent];
            _itemSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"item%@.png", itemData.iconId]];
            if (_useFrame) {
                _itemSprite.contentSize = self.contentSize;
            } else {
                _itemSprite.scaleX = self.contentSize.width / _itemSprite.contentSize.width;
                _itemSprite.scaleY = self.contentSize.height / _itemSprite.contentSize.height;
            }
            _itemSprite.anchorPoint = ccp(0.5, 0.5);
            _itemSprite.positionType = CCPositionTypeNormalized;
            _itemSprite.position = ccp(0.5, 0.5);
            [self addChild:_itemSprite];
        }
    } else {
        if (_itemSprite) {
            [_itemSprite removeFromParent];
            _itemSprite = nil;
        }
    }
    
    _itemData = gameItemData;
}


-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{ 
    if (_itemData) {
        [_delegate selectItem:_itemData];
    } else {
        if (self.itemCategory) {
            [_delegate selectItemByCategory:self.itemCategory];
        } else if (self.itemType) {
            [_delegate selectItemByType:self.itemType];
        }
    }
}

@end
