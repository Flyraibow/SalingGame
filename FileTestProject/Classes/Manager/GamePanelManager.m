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

+(DialogPanel *)sharedDialogPanelAboveSprite:(CCSprite *)sprite hidden:(BOOL)hidden
{
    if (_sharedDialogPanel == nil) {
        CGSize size = [CCDirector sharedDirector].viewSize;
        _sharedDialogPanel = [[DialogPanel alloc] initWithContentSize:size];
    }
    _sharedDialogPanel.coverSprite = sprite;
    _sharedDialogPanel.hideSprite = hidden;
    return _sharedDialogPanel;
}

+(DialogPanel *)sharedDialogPanelAboveSprite:(CCSprite *)sprite;
{
    return [self sharedDialogPanelAboveSprite:sprite hidden:NO];
}

+(BOOL)isInDialog
{
    return _sharedDialogPanel.parent != nil;
}

+(void)addConfirmHandler:(void(^)())handler
{
    [_sharedDialogPanel addConfirmHandler:handler];
}

@end
