//
//  BaseButtonGroup.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BaseFrame.h"

@class EventActionData;
@interface BaseButtonGroup : BaseFrame 

@property (nonatomic, weak) CCScene *baseScene;
@property (nonatomic, assign) BOOL hidden;

-(instancetype)initWithEventActionData:(EventActionData *)eventData;

-(instancetype)initWithNSArray:(NSArray *)buttonGroup;
-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor;
-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor withCloseButton:(BOOL)closeButton;

-(void)setCallback:(void(^)(int index))handler;

@end
