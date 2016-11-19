//
//  RolePanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"

typedef enum : NSUInteger {
    RolePanelTypeNormal,
    RolePanelTypeEquip,
} RolePanelType;

@interface RolePanel : BasePanel

@property (nonatomic, readonly) RolePanelType type;
@property (nonatomic) void(^selectHandler)(NSString *npcId);

@end
