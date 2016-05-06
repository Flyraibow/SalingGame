//
//  ItemIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "ItemData.h"

@protocol ItemIconSelectionDelegate <NSObject>

-(void)selectItem:(ItemData *)itemData;

@end

@interface ItemIcon : CCSprite

@property (nonatomic, weak) ItemData* itemData;

@property (nonatomic, weak) id<ItemIconSelectionDelegate> delegate;

@end
