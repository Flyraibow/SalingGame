//
//  PressDownButton.h
//  FileTestProject
//
//  Created by Yujie Liu on 1/3/18.
//  Copyright © 2018 Yujie Liu. All rights reserved.
//

#import "CCButton.h"
#import "CCButton+Ext.h"

// For pressDownButton, the event will be triggered at the beginning of
// press down, and continous triggering until it's up
@interface PressDownButton : CCButton

@property (nonatomic, assign) BOOL continuousEvent;

@end
