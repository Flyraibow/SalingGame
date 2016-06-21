//
//  CannonSelectionPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/20/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "PopUpFrame.h"
#import "GameCityData.h"

@protocol CannonSelectionPanelDelegate <NSObject>

-(void)selectCannon:(int)cannonPower;

@end

@interface CannonSelectionPanel : PopUpFrame

@property (nonatomic, weak) id<CannonSelectionPanelDelegate> delegate;

-(instancetype)initWithCannonList:(NSArray *)cannonList currPower:(int)cannonPower;

@end
