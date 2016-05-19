//
//  BaseDialogSprite.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"
#import "DialogPanel.h"

@interface BaseDialogSprite : CCSprite <DialogInteractProtocol>

@property (nonatomic, assign) BOOL showingDialog;

-(void)showDialog:(NSString *)portraitId npcName:(NSString *)npcName text:(NSString *)text;
-(void)showDialog:(NSString *)npcId text:(NSString *)text;
-(void)showDialog:(NSString *)portraitId
          npcName:(NSString *)npcName
             text:(NSString *)text
          options:(NSArray *)array
         callback:(void(^)(int index))handler;

-(void)showDialog:(NSString *)npcId
             text:(NSString *)text
          options:(NSArray *)array
         callback:(void(^)(int index))handler;

-(void)removeDialogPanel;
@end
