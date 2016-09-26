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
    ItemBrowsePanelTypeEquip,
    ItemBrowsePanelTypeSingle,
} ItemBrowsePanelType;

@protocol ItemInfoPanelDelegate <NSObject>

-(void)selectItemFromInfoPanel:(GameItemData *)gameItemData;

@optional
-(void)closeItemInfoPanel;
-(void)selectPrevItem;
-(void)selectNextItem;

@end

@interface ItemInfoPanel : BaseFrame

@property (nonatomic, weak) id<ItemInfoPanelDelegate> delegate;
@property (nonatomic) GameItemData *itemData;
@property (nonatomic, weak) NSString *equipedRoleId;            // used for preselected situation

-(instancetype)initWithPanelType:(ItemBrowsePanelType)type;

@end
