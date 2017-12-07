//
//  SailMapPanel.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/27/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"
#import "CityDataPanel.h"

@protocol SailMapPanelDelegate

-(void)seaAreaIdChanged:(NSString *)seaId;

-(void)clickCity:(NSString *)cityNo;

-(void)clickTeam:(NSString *)teamNo;

@end

@interface SailMapPanel : CCSprite

- (instancetype)initWithDelegate:(id<SailMapPanelDelegate>)delegate
                            type:(SailSceneType)type;

- (void)setSeaId:(NSString *)seaId;

@end
