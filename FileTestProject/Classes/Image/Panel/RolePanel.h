//
//  RolePanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
    RolePanelTypeNormal,
    RolePanelTypeEquip,
} RolePanelType;

@interface RolePanel : CCSprite

@property (nonatomic, readonly) RolePanelType type;
@property (nonatomic) void(^selectHandler)(NSString *npcId);

-(instancetype)initWithNpcList:(NSArray *)npcList type:(RolePanelType)type;

@end
