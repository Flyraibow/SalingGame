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
#import "ItemInfoPanel.h"
#import "SpriteUpdateProtocol.h"

@interface ItemBrowsePanel : BaseFrame

@property (nonatomic, weak) NSString *equipedRoleId;    // used for preselected situation
@property (nonatomic, weak) NSString *equipedShipId;    // used for preselected situation
@property (nonatomic, weak) id<SpriteUpdateProtocol> delegate;

@end
