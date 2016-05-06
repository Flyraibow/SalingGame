//
//  ItemBrowsePanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BaseFrame.h"

typedef enum : NSUInteger {
    ItemBrowsePanelTypeBuy,
    ItemBrowsePanelTypeSell,
    ItemBrowsePanelTypeBrowse,
} ItemBrowsePanelType;

@interface ItemBrowsePanel : BaseFrame

// 设置items的id列表， 城市和玩家身上都要有这个属性
-(instancetype)initWithItems:(NSArray *)items panelType:(ItemBrowsePanelType)type;

@end
