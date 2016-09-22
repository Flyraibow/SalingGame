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
#import "CCSprite+Ext.h"

@implementation RoleInfoPanel
{
    CCLabelTTF *_labNpcName;
    CCSprite *_photo;
    CCLabelTTF *_labGender;
    CCLabelTTF *_labLuck;
    CCLabelTTF *_labStrength;
    CCLabelTTF *_labAgile;
    CCLabelTTF *_labCharm;
    CCLabelTTF *_labIntelligence;
    CCLabelTTF *_labEloquence;
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
        _labNpcName.anchorPoint = ccp(0,1);
        _labNpcName.position = ccp(0.22, 0.95);
        [self addChild:_labNpcName];
        
        _labGender = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labGender.positionType = CCPositionTypeNormalized;
        _labGender.anchorPoint=ccp(0,1);
        _labGender.position = ccp(0.715, 0.765);
        [self addChild:_labGender];
        
        _labStrength = [CCLabelTTF labelWithString:getLocalString(@"lab_strength") fontName:nil fontSize:12];
        _labStrength.positionType = CCPositionTypePoints;
        _labStrength.position = ccp(504, 225);
        [self addChild:_labStrength];
        
        _labIntelligence = [CCLabelTTF labelWithString:getLocalString(@"lab_intelligence") fontName:nil fontSize:12];
        _labIntelligence.positionType = CCPositionTypePoints;
        _labIntelligence.position = ccp(602, 225);
        [self addChild:_labIntelligence];
        
        _labEloquence = [CCLabelTTF labelWithString:getLocalString(@"lab_eloquence") fontName:nil fontSize:12];
        _labEloquence.positionType = CCPositionTypePoints;
        _labEloquence.position = ccp(613, 185);
        [self addChild:_labEloquence];
        
        _labCharm = [CCLabelTTF labelWithString:getLocalString(@"lab_charm") fontName:nil fontSize:12];
        _labCharm.positionType = CCPositionTypePoints;
        _labCharm.position = ccp(602, 145);
        [self addChild:_labCharm];
        
        _labLuck = [CCLabelTTF labelWithString:getLocalString(@"lab_luck") fontName:nil fontSize:12];
        _labLuck.positionType = CCPositionTypePoints;
        _labLuck.position = ccp(506, 145);
        [self addChild:_labLuck];
        
        _labAgile = [CCLabelTTF labelWithString:getLocalString(@"lab_agile") fontName:nil fontSize:12];
        _labAgile.positionType = CCPositionTypePoints;
        _labAgile.position = ccp(493, 185);
        [self addChild:_labAgile];
    }
    
    return self;
}


-(void)setRoleId:(NSString *)roleId
{
    if(![_roleId isEqualToString:roleId])
    {
        _roleId=roleId;
        GameNPCData *npcData=[[GameNPCData alloc]initWithNpcId:_roleId];
                
        _labNpcName.string=npcData.fullName;
        if(_photo!=nil)
            [self removeChild:_photo];
        _photo = [CCSprite spriteWithImageNamed:npcData.portrait];
        [_photo setRect:CGRectMake(25, 154, 78, 95)];
        [self addChild:_photo];
        
        _labGender.string = getLocalStringByInt(@"gender_", npcData.npcData.gender + 1);
    }
}

-(void)clickCloseButton
{
    [self.delegate closePanel];
}

@end
