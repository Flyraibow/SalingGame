//
//  ItemBrowsePanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BasePanel.h"
#import "ItemInfoPanel.h"

@interface ItemBrowsePanel : BasePanel

@property (nonatomic, weak) NSString *equipedRoleId;    // used for preselected situation
@property (nonatomic, weak) NSString *equipedShipId;    // used for preselected situation

@end
