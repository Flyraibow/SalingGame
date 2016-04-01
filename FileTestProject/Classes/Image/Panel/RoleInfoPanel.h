//
//  RoleInfoPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@protocol RoleInfoPanelDelegate <NSObject>

-(void)closePanel;

@end

@interface RoleInfoPanel : CCSprite

@property (nonatomic) id<RoleInfoPanelDelegate> delegate;

-(void)setRoleId:(NSString *)roleId;

@end
