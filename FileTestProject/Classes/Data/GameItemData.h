//
//  GameItemData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemData.h"

@interface GameItemData : NSObject

@property (nonatomic, weak) ItemData *itemData;
@property (nonatomic) NSString *cityNo;             // 如果某个城市拥有，则为城市id
@property (nonatomic) NSString *guildId;            // 如果道具目前在某个公会，则有公会id
@property (nonatomic) NSString *roleId;             // 装备了这个道具的角色id
@property (nonatomic) NSString *shipId;             // 装备了这条船的shipId， TODO：目前好像ship暂时还没id，待定
                                                    // TODO: 其他还有在某个海域等待探险
@end
