//
//  RoleJobAnimation.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RoleAnimation.h"
#import "GameNPCData.h"

@interface RoleJobAnimation : RoleAnimation

@property (nonatomic, weak) GameNPCData *npcData;
@property (nonatomic, assign) int roomId;

@end
