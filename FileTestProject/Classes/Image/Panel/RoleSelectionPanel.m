//
//  RoleSelectionPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RoleSelectionPanel.h"
#import "GameDataManager.h"
#import "GameNPCData.h"
#import "RoleAnimation.h"

@interface RoleSelectionPanel() <RoleSelectionProtocol>

@end

@implementation RoleSelectionPanel
{
    RoleAnimation *_selectedAnimation;
}


-(instancetype)initWithNPCList:(NSArray *)npcList
{
    if (self = [super initWithImageNamed:@"InfoBox.jpg"]) {
        self.positionType = CCPositionTypeNormalized;
        self.anchorPoint = ccp(0.5, 0);
        self.position = ccp(0.5, 0);
        
        for (int j = 0; j < npcList.count; ++j) {
            GameNPCData *npcData = [npcList objectAtIndex:j];
            RoleAnimation *roleAnimation = [[RoleAnimation alloc] initWithRoleId:npcData.npcId];
            roleAnimation.userInteractionEnabled = YES;
            roleAnimation.action = ActionTypeStanding;
            roleAnimation.positionType = CCPositionTypePoints;
            roleAnimation.delegate = self;
            double scale = 1.5f;
            roleAnimation.scale = scale;
            roleAnimation.position = ccp(roleAnimation.contentSize.width * (j + 0.5), self.contentSize.height - roleAnimation.contentSize.height);
            [self addChild:roleAnimation];
            if (_selectedAnimation == nil) {
                [self selectRoleAnimation:roleAnimation];
            }
        }
    }
    return self;
}

-(void)selectRoleAnimation:(id)roleAnimation
{
    if (roleAnimation != nil) {
        _selectedAnimation = roleAnimation;
        [self.delegate selectRole:_selectedAnimation.roleId];
    }
}

@end
