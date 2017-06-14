//
//  TaskPanel.h
//  FileTestProject
//
//  Created by Yujie Liu on 5/30/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"

typedef enum : NSUInteger {
  TaskPanelTypeReview,
  TaskPanelTypeAccept,
} TaskPanelType;


@class GameTaskData;

@interface TaskPanel : BasePanel

@end
