//
//  MoneyPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface MoneyPanel : CCSprite

-(instancetype)initWithText:(NSString *)labelText;

-(void)setMoney:(NSInteger)money;

@end
