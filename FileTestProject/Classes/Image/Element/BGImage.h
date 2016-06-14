//
//  BGImage.h
//  FileTestProject
//
//  Created by LIU YUJIE on 1/29/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "DialogPanel.h"

@interface BGImage : CCSprite

+(CCSprite *)getBgImageByName:(NSString *)imageName;

+(CCNodeColor *)getShadowForBackground;
+(CCNodeColor *)getTransparentBackground;

+(void)initWithGroundSize:(CGSize)contentSize;

@end
