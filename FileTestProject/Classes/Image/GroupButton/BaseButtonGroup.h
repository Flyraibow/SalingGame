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

@class CityBuildingGroup;
@interface BaseButtonGroup : BaseFrame 

@property (nonatomic, weak) CityBuildingGroup *baseSprite;
@property (nonatomic, copy) NSString *buildingNo;
@property (nonatomic, assign) int cityStle;
@property (nonatomic, assign) BOOL hidden;

-(instancetype)initWithNSArray:(NSArray *)buttonGroup;
-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor;
-(instancetype)initWithNSArray:(NSArray *)buttonGroup CCNodeColor:(CCNodeColor *)nodeColor withCloseButton:(BOOL)closeButton;

-(void)showDefaultText:(NSString *)text;
-(void)confirm;
-(void)setCallback:(void(^)(int index))handler;
-(void)clickCloseButton;

@end
