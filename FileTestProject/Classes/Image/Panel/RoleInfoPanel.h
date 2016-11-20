//
//  RoleInfoPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@class GameItemData;
@protocol RoleInfoPanelDelegate <NSObject>

-(void)closePanel;
-(void)selectItemCategory:(NSInteger)category;
-(void)selectItem:(GameItemData *)itemData;

@end

@interface RoleInfoPanel : CCSprite

@property (nonatomic) id<RoleInfoPanelDelegate> delegate;
@property (nonatomic, readwrite) NSString *roleId;

@end
