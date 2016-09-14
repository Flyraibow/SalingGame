//
//  DockYardScene.h
//  FileTestProject
//
//  Created by Yujie Liu on 9/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameTeamData.h"

@interface DockYardScene : CCScene

@property (nonatomic, copy) NSString *cityId;

-(instancetype)initWithTeam:(GameTeamData *)team extraShipList:(NSArray<GameShipData *> *)shipList;

@end
