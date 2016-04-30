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
#import "GameNPCData.h"

@implementation RoleInfoPanel
{
    NSString *_roleId;
    CCLabelTTF *_labNpcName;
}

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
        
        [self setRoleId:@("1")];
        
//        _labNpcName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
//        _labNpcName.positionType = CCPositionTypeNormalized;
//        _labNpcName.position = ccp(0.1, 0.5);
//        _labNpcName.anchorPoint=ccp(0,1);
//        [self addChild:_labNpcName];
    }
    
    return self;
}


-(void)setRoleId:(NSString *)roleId
{
    NSLog(@"test of set RoleId");
    if(![_roleId isEqualToString:roleId])
    {
        _roleId=roleId;
        GameNPCData *npcData=[[GameNPCData alloc]initWithNpcId:_roleId];
        NSLog(@"%@",npcData.npcId);
        NSLog(@"%@",npcData.firstName);
        NSLog(@"%@",npcData.lastName);
        NSLog(@"%@",npcData.fullName);
        NSLog(@"%@",npcData.portrait);
        CCSprite *photo = [CCSprite spriteWithImageNamed:npcData.portrait];
        _labNpcName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labNpcName.positionType = CCPositionTypeNormalized;
        _labNpcName.position = ccp(0.1, 0.5);
        _labNpcName.anchorPoint=ccp(0,1);
        [self addChild:_labNpcName];

        _labNpcName.string=npcData.fullName;
        photo.anchorPoint=ccp(0,1);
        photo.positionType=CCPositionTypeNormalized;
        photo.position=ccp(0.045,0.90);
        photo.scale=0.44;
        [self addChild:photo];


    }
}

-(void)clickCloseButton
{
    [self.delegate closePanel];
}

@end
