//
//  ItemIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ItemIcon.h"

@implementation ItemIcon
{
    CCSprite *_itemSprite;
}

-(instancetype)init
{
    if (self = [super initWithImageNamed:@"shipIconFrame.png"]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setItemData:(GameItemData *)gameItemData
{
    ItemData *itemData = gameItemData.itemData;
    if (![itemData.iconId isEqualToString:_itemData.itemData.iconId]) {
        [_itemSprite removeFromParent];
        _itemSprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"item%@.png", itemData.iconId]];
        _itemSprite.contentSize = self.contentSize;
        _itemSprite.anchorPoint = ccp(0.5, 0.5);
        _itemSprite.positionType = CCPositionTypeNormalized;
        _itemSprite.position = ccp(0.5, 0.5);
        [self addChild:_itemSprite];
    }
    _itemData = gameItemData;
}


-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate selectItem:_itemData];
}

@end
