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
#import "ItemData.h"

typedef enum : NSUInteger {
    ItemBrowsePanelTypeBuy,
    ItemBrowsePanelTypeSell,
    ItemBrowsePanelTypeBrowse,
} ItemBrowsePanelType;

@protocol ItemInfoPanelDelegate

-(void)closeItemInfoPanel;

-(void)selectItemFromInfoPanel:(ItemData *)itemData;

@end

@interface ItemInfoPanel : BaseFrame

@property (nonatomic, weak) id<ItemInfoPanelDelegate> delegate;

-(instancetype)initWithItemData:(ItemData *)itemData panelType:(ItemBrowsePanelType)type;;

@end
