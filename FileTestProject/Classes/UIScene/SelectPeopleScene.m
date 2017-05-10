//
//  SelectPeopleScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SelectPeopleScene.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "SelectPeopleIcon.h"
#import "LocalString.h"
#import "RoleInitialData.h"
#import "RoleDescriptionScene.h"

@interface SelectPeopleScene() <PeopleIconSelectionDelegate>

@end

@implementation SelectPeopleScene
{
    NSDictionary *_dataDict;
}

-(instancetype)initWithInitialList:(NSDictionary *)dataDict
{
    if (self = [super init]) {
        CCSprite *bg = [BGImage getBgImageByName:@"bg_System.png"];
        [self addChild:bg];
        _dataDict = dataDict;
        NSInteger roleNumber = dataDict.count;
        NSInteger index = 0;
        for (NSString *roleId in dataDict) {
            RoleInitialData *roleData = [dataDict objectForKey:roleId];
            SelectPeopleIcon *icon = [[SelectPeopleIcon alloc] initWithRoleId:roleId rolePhotoId:roleData.rolePhotoId];
            icon.positionType = CCPositionTypeNormalized;
            // TODO: adjust the position of each photo
            if (roleNumber < 4) {
                icon.position = ccp(1.0 * (index + 1) / (roleNumber + 1 ), 0.5);
            }
            icon.delegate = self;
            index++;
            [self addChild:icon];
        }
        
        DefaultButton *btnCancel = [DefaultButton buttonWithTitle:getLocalString(@"btn_cancel")];
        btnCancel.positionType = CCPositionTypeNormalized;
        btnCancel.position = ccp(0.85, 0.1);
        btnCancel.scale = 0.5;
        [btnCancel setTarget:self selector:@selector(clickCancelButton)];
        [self addChild:btnCancel];
        
    }
    return self;
}

-(void)selectPeople:(NSString *)roleId
{
    [[CCDirector sharedDirector] pushScene:[[RoleDescriptionScene alloc] initWithInitialRole:[_dataDict objectForKey:roleId]]];
}


-(void)clickCancelButton
{
    [[CCDirector sharedDirector] popScene];
}

@end
