//
//  RolePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/12/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RolePanel.h"
#import "RoleSelectionPanel.h"
#import "RoleInfoPanel.h"
#import "BGImage.h"
#import "GameNPCData.h"

@interface RolePanel() <RoleInfoPanelDelegate, RoleSelectionPanelDelegate>

@end

@implementation RolePanel
{
    RoleSelectionPanel *_roleSelectionPanel;
    RoleInfoPanel *_roleInfoPanel;
    
    CGSize _contentSize;
}

-(instancetype)initWithNpcList:(NSArray *)npcList type:(RolePanelType)type
{
    if (self = [super init]) {
        _type = type;
        
        _contentSize = [CCDirector sharedDirector].viewSize;
        self.contentSize = _contentSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.userInteractionEnabled = YES;
        [self addChild:[BGImage getShadowForBackground]];
        
        _roleInfoPanel = [[RoleInfoPanel alloc] init];
        _roleInfoPanel.scale = _contentSize.height * 0.6 / _roleInfoPanel.contentSize.height;
        _roleInfoPanel.delegate = self;
        [self addChild:_roleInfoPanel];
        
        _roleSelectionPanel = [[RoleSelectionPanel alloc] initWithNPCList:npcList];
        _roleSelectionPanel.delegate=self;
        _roleSelectionPanel.scale = _contentSize.height * 0.4 / _roleSelectionPanel.contentSize.height;
        [self addChild:_roleSelectionPanel];
        
        if (npcList.count) {
            GameNPCData *npcData = npcList[0];
            [self selectRole:npcData.npcId];
        }
    }
    return self;
}

-(void)closePanel
{
    [self removeFromParent];
}

-(void)selectRole:(NSString *)roleId
{
    if ([_roleInfoPanel.roleId isEqualToString:roleId]) {
        if (roleId && self.selectHandler != nil) {
            // 再次点击才相应事件
            self.selectHandler(roleId);
        }
    } else {
        [_roleInfoPanel setRoleId:roleId];
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // swallow click
}

@end
