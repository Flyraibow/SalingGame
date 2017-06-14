//
//  CityTaskButtonGroup.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/23/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "CityTaskButtonGroup.h"
#import "DefaultButton.h"
#import "GameTaskData.h"
#import "BGImage.h"
#import "TaskPanel.h"
#import "GameValueManager.h"

@implementation CityTaskButtonGroup
{
    __weak NSArray<GameTaskData *> *_task;
}


- (instancetype)initWithTasks:(NSArray<GameTaskData *> *)tasks
{
    _task = tasks;
    NSMutableArray *buttons = [NSMutableArray new];
    for (int i = 0; i < tasks.count; ++i) {
        GameTaskData *task = tasks[i];
        DefaultButton *button = [[DefaultButton alloc] initWithTitle:task.title];
        button.name = [@(i) stringValue];
        [button setTarget:self selector:@selector(clickButton:)];
        [buttons addObject:button];
    }
    if (self = [super initWithNSArray:buttons CCNodeColor:[BGImage getShadowForBackground] withCloseButton:YES]) {
        
    }
    return self;
}

- (void)clickButton:(DefaultButton *)button
{
    int index = [button.name intValue];
    NSAssert(_task[index], @"selected task cannot be nil");
    [GameValueManager sharedValueManager].reservedTaskData = _task[index];
    self.completionBlockWithEventId(@"taskBoard");
}

@end
