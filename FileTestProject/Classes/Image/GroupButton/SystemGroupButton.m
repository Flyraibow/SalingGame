//
//  SystemGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/3/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SystemGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "ProgressScene.h"
#import "BGImage.h"

@implementation SystemGroupButton

-(instancetype)init
{
    DefaultButton *btnSave = [DefaultButton buttonWithTitle:getLocalString(@"lab_save")];
    DefaultButton *btnLoad = [DefaultButton buttonWithTitle:getLocalString(@"lab_load")];
    DefaultButton *btnSetting = [DefaultButton buttonWithTitle:getLocalString(@"lab_setting")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnSave,btnLoad,btnSetting, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        [btnSave setTarget:self selector:@selector(clickSaveBtn)];
        [btnLoad setTarget:self selector:@selector(clickLoadBtn)];
        [btnSetting setTarget:self selector:@selector(clickSettingBtn)];
    }
    return self;
}

-(void)clickSaveBtn
{
    [[CCDirector sharedDirector] pushScene:[[ProgressScene alloc] initWithFunction:ProgressSave]];
}

-(void)clickLoadBtn
{
    [[CCDirector sharedDirector] pushScene:[[ProgressScene alloc] initWithFunction:ProgressLoad]];
}

-(void)clickSettingBtn
{
    
}

@end
