//
//  DialogPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@protocol DialogInteractProtocol <NSObject>

@optional
-(void)confirm;

@end

@interface DialogPanel : CCSprite

@property (nonatomic) id<DialogInteractProtocol> delegate;

-(instancetype)initWithContentSize:(CGSize)contentSize;

// used in story mode
-(void)setDialogWithPhotoNo:(NSString *)photoNo npcName:(NSString *)npcName text:(NSString *)text;

-(void)setDialogWithPhotoNo:(NSString *)photoNo npcName:(NSString *)npcName text:(NSString *)text handler:(void(^)())handler;

-(void)setDialogWithNpcId:(NSString *)npcId text:(NSString *)text;

-(void)addSelections:(NSArray *)selectArray callback:(void(^)(int index))handler;

-(void)setDefaultDialog:(NSString *)defaultDialogId arguments:(NSArray *)arguments cityStyle:(int)cityStyle;

-(void)setDefaultDialog:(NSString *)defaultDialogId arguments:(NSArray *)arguments;

-(NSString *)replaceTextWithDefaultRegex:(NSString *)text;

@end
