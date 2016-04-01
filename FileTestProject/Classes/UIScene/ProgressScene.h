//
//  ProgressScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef NS_ENUM(NSInteger, ProgressType)  {
    ProgressSave,
    ProgressLoad,
    
};

@interface ProgressScene : CCScene

-(instancetype)initWithFunction:(ProgressType)type;

@end
