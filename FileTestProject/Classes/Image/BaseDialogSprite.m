//
//  BaseDialogSprite.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BaseDialogSprite.h"

@implementation BaseDialogSprite
{
    DialogPanel *_dialogPanel;
}

-(void)removeDialogPanel
{
    if (_dialogPanel.parent != nil) {
        [_dialogPanel removeFromParent];
        _dialogPanel = nil;
    }
    _showingDialog = NO;
}

-(void)initializeDialogPanel
{
    if (_dialogPanel == nil) {
        _dialogPanel = [[DialogPanel alloc] init];
        _dialogPanel.delegate = self;
    }
    if (_dialogPanel.parent == nil) {
        [self.scene addChild:_dialogPanel];
    }
}

-(void)showDialog:(NSString *)portraitId npcName:(NSString *)npcName text:(NSString *)text
{
    [self initializeDialogPanel];
    [_dialogPanel setDialogWithPhotoNo:portraitId npcName:npcName text:text];
    
    _showingDialog = YES;
}

-(void)showDialog:(NSString *)npcId text:(NSString *)text
{
    [self initializeDialogPanel];
    [_dialogPanel setDialogWithNpcId:npcId text:text];
    _showingDialog = YES;
}

-(void)showDialog:(NSString *)portraitId
          npcName:(NSString *)npcName
             text:(NSString *)text
          options:(NSArray *)array
         callback:(void (^)(int))handler
{
    [self showDialog:portraitId npcName:npcName text:text];
    [_dialogPanel addSelections:array callback:handler];
}

-(void)showDialog:(NSString *)npcId text:(NSString *)text options:(NSArray *)array callback:(void (^)(int))handler
{
    [self showDialog:npcId text:text];
    [_dialogPanel addSelections:array callback:handler];
}


-(void)confirm
{
    [self removeDialogPanel];
}


@end
