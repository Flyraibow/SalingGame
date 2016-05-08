//
//  GamePanelManager.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/7/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GamePanelManager.h"
#import "CCDirector.h"

static DialogPanel *_sharedDialogPanel;

@implementation GamePanelManager

+(DialogPanel *)sharedDialogPanelWithDelegate:(id<DialogInteractProtocol>)delegate
{
    if (_sharedDialogPanel == nil) {
        CGSize size = [CCDirector sharedDirector].viewSize;
        _sharedDialogPanel = [[DialogPanel alloc] initWithContentSize:size];
    }
    _sharedDialogPanel.delegate = delegate;
    return _sharedDialogPanel;
}

@end
