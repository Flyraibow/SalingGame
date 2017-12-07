//
//  CityDataPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
    SailSceneTypeRead,
    SailSceneTypeGo,
    SailSceneTypeTradeInfo,
} SailSceneType;

@interface CityDataPanel : CCSprite

@property (nonatomic, readonly, assign) SailSceneType sceneType;

-(instancetype)initWithCityNo:(NSString *)cityNo sceneType:(SailSceneType)sceneType;

-(void)setCityNo:(NSString *)cityNo;

@end
