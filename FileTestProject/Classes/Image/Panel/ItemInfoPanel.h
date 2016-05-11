//
//  ItemInfoPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BaseFrame.h"
#import "GameItemData.h"

typedef enum : NSUInteger {
    ItemBrowsePanelTypeBuy,
    ItemBrowsePanelTypeSell,
    ItemBrowsePanelTypeBrowse,
} ItemBrowsePanelType;

@protocol ItemInfoPanelDelegate

-(void)closeItemInfoPanel;

-(void)selectItemFromInfoPanel:(GameItemData *)gameItemData;

-(void)selectPrevItem;

-(void)selectNextItem;

@end

@interface ItemInfoPanel : BaseFrame

@property (nonatomic, weak) id<ItemInfoPanelDelegate> delegate;
@property (nonatomic) GameItemData *itemData;

-(instancetype)initWithPanelType:(ItemBrowsePanelType)type;

@end
