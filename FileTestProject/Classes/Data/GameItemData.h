//
//  GameItemData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/8/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemData.h"

@interface GameItemData : NSObject <NSCoding>

@property (nonatomic, weak) ItemData *itemData;

@property (nonatomic, readonly) NSString *itemId;             
@property (nonatomic, readonly) NSString *cityNo;             // 如果某个城市拥有，则为城市id
@property (nonatomic, readonly) NSString *guildId;            // 如果道具目前在某个公会，则有公会id
@property (nonatomic, readonly) NSString *roleId;             // 装备了这个道具的角色id
@property (nonatomic, readonly) NSString *shipId;             // 装备了这条船的shipId， TODO：目前好像ship暂时还没id，待定
@property (nonatomic, readonly) NSString *itemName;
@property (nonatomic, assign, readonly) BOOL exist;           // 是否存在

-(instancetype)initWithItemData:(ItemData *)itemData;

-(void)boughtByGuildNo:(NSString *)guildNo;
-(void)sellToCityNo:(NSString *)cityNo;
-(void)unlockGoods;

@end
