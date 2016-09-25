//
//  ItemIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameItemData.h"

@protocol ItemIconSelectionDelegate <NSObject>

-(void)selectItem:(GameItemData *)itemData;

@optional
-(void)selectItemByCategory:(ItemCategory)itemCategory;

@end

@interface ItemIcon : CCSprite

// 用于应对空的Item的响应返回内容
@property (nonatomic, assign) ItemCategory itemCategory;

@property (nonatomic, weak) GameItemData* itemData;

@property (nonatomic, weak) id<ItemIconSelectionDelegate> delegate;

@end
