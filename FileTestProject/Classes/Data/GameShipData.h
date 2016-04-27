//
//  GameShipData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipData.h"

@interface GameShipData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *shipNo;
@property (nonatomic, readonly) NSString *shipIcon;
@property (nonatomic, copy) NSString *belongToGuild;
@property (nonatomic) NSString *shipName;

@property (nonatomic, readonly) int maxSailorNum;
@property (nonatomic, readonly) int minSailorNum;
@property (nonatomic, readonly) int curSailorNum;
@property (nonatomic, readonly) int capacity;
@property (nonatomic, readonly) int foodCapacity;
@property (nonatomic, readonly) int maxFoodCapacity;
@property (nonatomic, readonly) int duration;
@property (nonatomic, readonly) int maxDuration;
@property (nonatomic, readonly) int agile;
@property (nonatomic, readonly) int speed;
@property (nonatomic, readonly) int cannonNum;
@property (nonatomic, readonly) int cannonPower;
@property (nonatomic, readonly) int spareRoom;
@property (nonatomic, readonly) NSMutableArray *goodsList;
@property (nonatomic, readonly, weak) ShipData *shipData;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) NSArray *equipList;


-(instancetype)initWithShipData:(ShipData *)shipData;

@end
