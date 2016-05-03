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
    CCSprite *_photo;
    CCLabelTTF *_labGender;
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
        
        _labNpcName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labNpcName.positionType = CCPositionTypeNormalized;
        _labNpcName.anchorPoint=ccp(0,1);
        _labNpcName.position = ccp(0.22, 0.95);
        [self addChild:_labNpcName];
        
        _labGender = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labGender.positionType = CCPositionTypeNormalized;
        _labGender.anchorPoint=ccp(0,1);
        _labGender.position = ccp(0.715, 0.765);
        [self addChild:_labGender];
        
        //[self setRoleId:@("1")];

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
                
        _labNpcName.string=npcData.fullName;
        if(_photo!=nil)
            [self removeChild:_photo];
        _photo = [CCSprite spriteWithImageNamed:npcData.portrait];
        _photo.anchorPoint=ccp(0,1);
        _photo.positionType=CCPositionTypeNormalized;
        _photo.position=ccp(0.045,0.90);
        _photo.scale=0.44;
        [self addChild:_photo];
        
        _labGender.string=@"男";
        

    }
}

-(void)clickCloseButton
{
    [self.delegate closePanel];
}

@end
