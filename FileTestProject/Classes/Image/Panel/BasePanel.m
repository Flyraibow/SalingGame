//
//  BasePanel.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"
#import "InvestPanel.h"
#import "SailorNumberPanel.h"
#import "GameDataManager.h"
#import "GameValueManager.h"

@implementation BasePanel

- (instancetype)initWithArray:(NSArray *)array
{
    NSString *cityId = [GameDataManager sharedGameData].myGuild.myTeam.currentCityId;
    if ([self isKindOfClass:[InvestPanel class]]) {
        return [(InvestPanel*)self initWithCityId:cityId
                                       investType:[array[0] intValue]
                                     successEvent:array[1]
                                        failEvent:array[2]];
    } else if ([self isKindOfClass:[SailorNumberPanel class]]) {
        NSArray *shipList = [[GameDataManager sharedGameData].myGuild.myTeam shipDataList];
        NSInteger freeSailor = [[GameValueManager sharedValueManager] getNumberByTerm:array[0]];
        return [(SailorNumberPanel *)self initWithShipList:shipList
                                          freeSailorNumber:freeSailor
                                           completeEventId:array[1]];
    }
    return self;
}

@end
