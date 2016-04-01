//
//  DuleScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/16/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
    DuelResultWin,
    DuelResultLose,
    DuelResultTie,
    DuelResultStory
} DuelResult;

@protocol DuelSceneDelegate <NSObject>

-(void)duelEnds:(DuelResult)result;

@end

@interface DuelScene : CCScene

@property (nonatomic) id<DuelSceneDelegate> delegate;

// init the panel, with two roles, first one is the enemy, the second one is one mine
-(instancetype)initWithRoleId:(NSString *)roleId1 roleId:(NSString *)roleId2;

@end
