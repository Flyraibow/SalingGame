//
//  CityBuildingGroup.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/3/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@protocol CityBuildingDelegate <NSObject>

-(void)checkStory:(NSString *)buildingId;

@end

@interface CityBuildingGroup : CCSprite

@property (nonatomic, weak) id<CityBuildingDelegate> delegate;

-(void)setCityNo:(NSString *)cityNo;

-(void)setHidden:(BOOL)hidden;
-(void)closeButtonGroup:(id)buttonGroup;

-(void)gotoBuildingNo:(NSString *)buildingNo;

@end
