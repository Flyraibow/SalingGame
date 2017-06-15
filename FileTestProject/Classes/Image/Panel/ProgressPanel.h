//
//  ProgressScene.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"

typedef NS_ENUM(NSInteger, ProgressType)  {
    ProgressSave,
    ProgressLoad,
};

@interface ProgressPanel : BasePanel

-(instancetype)initWithFunction:(ProgressType)type;

@end
