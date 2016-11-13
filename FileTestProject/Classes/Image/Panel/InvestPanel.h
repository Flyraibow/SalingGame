//
//  InvestPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseFrame.h"
#import "GameCityData.h"

@protocol InvestPanelDelegate <NSObject>

-(void)investFailure;
-(void)investSucceed;

@end

@interface InvestPanel : BaseFrame

@property (nonatomic, assign) id<InvestPanelDelegate> delegate;

@end
