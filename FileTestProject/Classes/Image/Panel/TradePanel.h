//
//  TradeScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//


#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BasePanel.h"

@interface TradePanel : BasePanel

-(instancetype)initWithCityNo:(NSString *)cityNo
                 tradeSuccess:(NSString *)successEvent
                  tradeCancel:(NSString *)cancelEvent;

@end
