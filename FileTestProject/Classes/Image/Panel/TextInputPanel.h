//
//  TextInputPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "BasePanel.h"

@protocol TextInputPanelDelegate <NSObject>

-(void)setText:(NSString *)text;

@end

@interface TextInputPanel : BasePanel

@property (nonatomic, weak) id<TextInputPanelDelegate> delegate;
@property (nonatomic, readonly) CCTextField *textField;

-(instancetype)initWithText:(NSString *)text;

@end
