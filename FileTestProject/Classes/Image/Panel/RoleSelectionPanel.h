//
//  RoleSelectionPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@protocol RoleSelectionPanelDelegate <NSObject>

-(void)selectRole:(NSString *)roleId;

@end

@interface RoleSelectionPanel : CCSprite

@property (nonatomic) id<RoleSelectionPanelDelegate> delegate;

@end
