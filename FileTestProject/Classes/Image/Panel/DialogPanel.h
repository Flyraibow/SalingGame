//
//  DialogPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface DialogPanel : CCSprite

@property (nonatomic, assign) BOOL canRemove;
@property (nonatomic, assign) BOOL canShowCoverPanel;
@property (nonatomic, weak) CCSprite *coverSprite;
@property (nonatomic, assign) BOOL *hideSprite;

-(instancetype)initWithContentSize:(CGSize)contentSize;

// used in story mode
-(void)setDialogWithPhotoNo:(NSString *)photoNo npcName:(NSString *)npcName text:(NSString *)text;

-(void)setDialogWithPhotoNo:(NSString *)photoNo npcName:(NSString *)npcName text:(NSString *)text handler:(void(^)())handler;

-(void)setDialogWithNpcId:(NSString *)npcId text:(NSString *)text;

-(void)addYesNoWithCallback:(void(^)(int index))handler;

-(void)addConfirmHandler:(void(^)())handler;

-(void)addConfirmHandler:(void(^)())handler forAll:(BOOL)flag;

-(void)addSelections:(NSArray *)selectArray callback:(void(^)(int index))handler;

-(void)setDefaultDialog:(NSString *)defaultDialogId arguments:(NSArray *)arguments;

-(NSString *)replaceTextWithDefaultRegex:(NSString *)text;

-(void)cutConversation;

@end
