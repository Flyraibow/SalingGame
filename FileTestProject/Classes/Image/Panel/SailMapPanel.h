//
//  SailMapPanel.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/27/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@protocol SailMapPanelDelegate

-(void)seaAreaIdChanged:(NSString *)seaId;

@end

@interface SailMapPanel : CCSprite

- (instancetype)initWithDelegate:(id<SailMapPanelDelegate>)delegate SeaId:(NSString *)seaId;

- (void)setSeaId:(NSString *)seaId;

@end
