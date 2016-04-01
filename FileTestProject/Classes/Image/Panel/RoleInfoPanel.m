//
//  RoleInfoPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RoleInfoPanel.h"
#import "DefaultButton.h"
#import "LocalString.h"

@implementation RoleInfoPanel


-(instancetype)init
{
    if (self = [super initWithImageNamed:@"RoleInfoPanel.jpg"]) {
        self.positionType = CCPositionTypeNormalized;
        self.anchorPoint = ccp(0.5, 1);
        self.position = ccp(0.5, 1);
        
        DefaultButton *closeButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        closeButton.scale = 0.5;
        closeButton.anchorPoint = ccp(1,0);
        closeButton.positionType = CCPositionTypePoints;
        closeButton.position = ccp(self.contentSize.width - 10, 10);
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        [self addChild:closeButton];
    }
    
    return self;
}


-(void)setRoleId:(NSString *)roleId
{
    
}

-(void)clickCloseButton
{
    [self.delegate closePanel];
}

@end
