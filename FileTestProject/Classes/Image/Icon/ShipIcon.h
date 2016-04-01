//
//  ShipIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@protocol ShipIconSelectionDelegate <NSObject>

-(void)selectShipIconIndex:(id)shipIcon;

@end

@interface ShipIcon : CCSprite

@property (nonatomic, assign) int iconIndex;

@property (nonatomic, weak) id<ShipIconSelectionDelegate> delegate;

-(instancetype)initWithShipIconNo:(NSString *)shipIconNo;

@end
