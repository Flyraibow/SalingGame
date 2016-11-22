//
//  ItemInfoPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BasePanel.h"
#import "GameItemData.h"

typedef enum : NSUInteger {
    ItemBrowsePanelTypeBuy = 0,
    ItemBrowsePanelTypeSell = 1,
    ItemBrowsePanelTypeBrowse = 2,
    ItemBrowsePanelTypeEquip = 3,
    ItemBrowsePanelTypeSingle = 4,
    ItemBrowsePanelTypeShipHeader = 5,
} ItemBrowsePanelType;

NSArray *getItemsByPanelType(ItemBrowsePanelType type, NSString *cityId);

@interface ItemInfoPanel : BasePanel

@property (nonatomic) GameItemData *itemData;

@end
