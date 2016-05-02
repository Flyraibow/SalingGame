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


-(instancetype)init
{
    if (self = [super initWithImageNamed:@"InfoBox.jpg"]) {
        self.positionType = CCPositionTypeNormalized;
        self.anchorPoint = ccp(0.5, 0);
        self.position = ccp(0.5, 0);
        
        NSArray *teamList = [GameDataManager sharedGameData].myGuild.teamList;
        teamList = [teamList arrayByAddingObject:[GameDataManager sharedGameData].myGuild.myTeam];
        for (int i = 0; i < teamList.count; ++i) {
            GameTeamData *teamData = [teamList objectAtIndex:i];
            for (int j = 0; j < teamData.npcList.count; ++j) {
                GameNPCData *npcData = [teamData.npcList objectAtIndex:j];
                NSLog(@"NPC : %@", npcData.npcId);
                RoleAnimation *roleAnimation = [[RoleAnimation alloc] initWithRoleId:npcData.npcId];
                roleAnimation.userInteractionEnabled = YES;
                roleAnimation.action = ActionTypeStanding;
                roleAnimation.positionType = CCPositionTypePoints;
                double scale = 1.5f;
                roleAnimation.scale = scale;
                roleAnimation.position = ccp(roleAnimation.contentSize.width * (j + 0.5), self.contentSize.height - roleAnimation.contentSize.height);
                [self addChild:roleAnimation];
                if (_selectedAnimation == nil) {
                    [self selectRoleAnimation:roleAnimation];
                }
            }
        }
        
    }
    return self;
}

-(void)selectRoleAnimation:(id)roleAnimation
{
    if (_selectedAnimation != nil) {
        
    }
    _selectedAnimation = roleAnimation;
    [self.delegate selectRole:_selectedAnimation.roleId];
    NSLog(@"%@",_selectedAnimation.roleId);
    NSLog(@"%@",self.delegate);
}

@end
