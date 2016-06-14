//
//  TextInputPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "TextInputPanel.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"

@implementation TextInputPanel


-(instancetype)initWithText:(NSString *)text
{
    if (self = [super initWithNodeColor:[BGImage getTransparentBackground]]) {
        CCSprite *spriteBackground = [CCSprite spriteWithImageNamed:@"frame_input_panel.jpg"];
        spriteBackground.positionType = CCPositionTypeNormalized;
        spriteBackground.anchorPoint = ccp(0.5, 1);
        spriteBackground.position = ccp(0.5, 0.99);
        [self addChild:spriteBackground];
        
        _textField = [[CCTextField alloc] initWithSpriteFrame:nil];
        _textField.positionType = CCPositionTypeNormalized;
        _textField.anchorPoint = ccp(0, 0.5);
        _textField.position = ccp(0.02, 0.5);
        _textField.preferredSize = CGSizeMake(200, 30);
        _textField.textField.textColor = [UIColor whiteColor];
        _textField.textField.text = text;
        if([_textField.textField canBecomeFocused])
        {
            [_textField.textField becomeFirstResponder];
        }
        [spriteBackground addChild:_textField];
        
        DefaultButton *btnSure = [DefaultButton buttonWithTitle:getLocalString(@"btn_sure")];
        btnSure.positionType = CCPositionTypeNormalized;
        btnSure.anchorPoint = ccp(0.5, 0);
        btnSure.position = ccp(0.3, 0.1);
        [btnSure setTarget:self selector:@selector(clickSureButton)];
        [spriteBackground addChild:btnSure];
        
        DefaultButton *btnCancel = [DefaultButton buttonWithTitle:getLocalString(@"btn_cancel")];
        btnCancel.positionType = CCPositionTypeNormalized;
        btnCancel.anchorPoint = ccp(0.5, 0);
        btnCancel.position = ccp(0.7, 0.1);
        [btnCancel setTarget:self selector:@selector(clickCancelButton)];
        [spriteBackground addChild:btnCancel];
        
    }
    return self;
}

-(void)clickSureButton
{
    [_delegate setText:_textField.textField.text];
    [self removeFromParent];
}

-(void)clickCancelButton
{
    [self removeFromParent];
}


@end
