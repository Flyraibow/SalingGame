//
//  BasePanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"
#import "InvestPanel.h"
#import "GameDataManager.h"

@implementation BasePanel

- (instancetype)initWithArray:(NSArray *)array
{
    NSString *cityId = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
    if ([self isKindOfClass:[InvestPanel class]]) {
        return [(InvestPanel*)self initWithCityId:cityId
                                       investType:[array[0] intValue]
                                     successEvent:array[1]
                                        failEvent:array[2]];
    }
    return self;
}

@end
