//
//  ItemBrowsePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 5/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "ItemBrowsePanel.h"
#import "BGImage.h"
#import "LabelButton.h"
#import "LocalString.h"

@implementation ItemBrowsePanel
{
    CCSprite *_panel;
    NSMutableArray *_buttonList;
}

-(instancetype)init
{
    if (self = [super initWithNodeColor:[BGImage getShadowForBackground]]) {
        self.contentSize = [CCDirector sharedDirector].viewSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.anchorPoint = ccp(0.5, 0.5);
        
        _panel = [CCSprite spriteWithImageNamed:@"ItemBrowsePanel.jpg"];
        _panel.positionType = CCPositionTypeNormalized;
        _panel.position = ccp(0.5, 0.1);
        _panel.anchorPoint = ccp(0.5, 0);
        _panel.scale = (self.contentSize.height - 20) / _panel.contentSize.height * 0.8;
        [self addChild:_panel];
        
        _buttonList = [NSMutableArray new];
        for (int i = 0; i < 6; ++i) {
            LabelButton *labButton = [[LabelButton alloc] initWithTitle:getLocalStringByInt(@"item_category_", i + 1)];
            labButton.name = [@(i + 1) stringValue];
            labButton.anchorPoint = ccp(0.5, 0);
            labButton.positionType = CCPositionTypeNormalized;
            labButton.position = ccp(1.0 / 12 * (i * 2 + 1), 1);
            [labButton setTarget:self selector:@selector(clickLabelButton:)];
            
            [_panel addChild:labButton];
            [_buttonList addObject:labButton];
        }
        
        
    }
    return self;
}

-(void)clickLabelButton:(LabelButton *)button
{
    
}

@end
