//
//  RoleDescriptionScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RoleDescriptionScene.h"
#import "BGImage.h"
#import "SelectPeopleIcon.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "DataManager.h"
#import "GameDataManager.h"
#import "CityScene.h"
#import "CCSprite+Ext.h"
#import "CGStoryScene.h"
#import "GameStoryTriggerManager.h"

@implementation RoleDescriptionScene
{
    RoleInitialData *_roleData;
}

-(instancetype)initWithInitialRole:(RoleInitialData *)roleData
{
    if (self = [super init]) {
        CCSprite *bg = [BGImage getBgImageByName:@"bg_System.png"];
        [self addChild:bg];
        
        _roleData = roleData;
        
        CCSprite *photoFrame = [CCSprite spriteWithImageNamed:@"bigPhotoFrame.png"];
        photoFrame.positionType = CCPositionTypeNormalized;
        photoFrame.anchorPoint = ccp(0,0.5);
        photoFrame.position = ccp(0.1, 0.5);
        [self addChild:photoFrame];
        CCSprite *photo = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Portrait%d.png", roleData.rolePhotoId]];
        [photo setRect:CGRectMake(32, 64, 210, 258)];
        [photoFrame addChild:photo];
        photoFrame.scale = 0.7;
        
        DefaultButton *btnSure = [DefaultButton buttonWithTitle:getLocalString(@"btn_sure")];
        btnSure.positionType = CCPositionTypeNormalized;
        btnSure.position = ccp(0.65, 0.1);
        btnSure.scale = 0.5;
        [btnSure setTarget:self selector:@selector(clickSureButton)];
        [self addChild:btnSure];
        
        DefaultButton *btnCancel = [DefaultButton buttonWithTitle:getLocalString(@"btn_cancel")];
        btnCancel.positionType = CCPositionTypeNormalized;
        btnCancel.position = ccp(0.85, 0.1);
        btnCancel.scale = 0.5;
        [btnCancel setTarget:self selector:@selector(clickCancelButton)];
        [self addChild:btnCancel];
        
        GuildData *guildData = [[[DataManager sharedDataManager] getGuildDic] getGuildById:roleData.guildId];
        
        CCLabelTTF *labRoleName = [CCLabelTTF labelWithString:getNpcFirstName(guildData.leaderId) fontName:nil fontSize:12];
        labRoleName.positionType = CCPositionTypeNormalized;
        labRoleName.anchorPoint = ccp(0, 1);
        labRoleName.position = ccp(0.5,0.8);
        [self addChild:labRoleName];
        
        CCLabelTTF *labGuildName = [CCLabelTTF labelWithString:getGuildName(guildData.guildId) fontName:nil fontSize:12];
        labGuildName.positionType = CCPositionTypeNormalized;
        labGuildName.anchorPoint = ccp(0, 1);
        labGuildName.position = ccp(0.55,0.75);
        [self addChild:labGuildName];
        
        CGSize contentSize = [CCDirector sharedDirector].viewSize;
        CCLabelTTF *labNpcDescription = [CCLabelTTF labelWithString:getNpcDescription(guildData.leaderId) fontName:nil fontSize:12 dimensions:CGSizeMake(contentSize.width / 2 - 15, contentSize.height / 3)];
        labNpcDescription.positionType = CCPositionTypeNormalized;
        labNpcDescription.anchorPoint = ccp(0, 1);
        labNpcDescription.position = ccp(0.5,0.6);
        [self addChild:labNpcDescription];
        
        
    }
    return self;
}

-(void)clickSureButton
{
    // initialize the data
    
    GameGuildData *guildData = [[GameDataManager sharedGameData].guildDic objectForKey:_roleData.guildId];
    [[GameDataManager sharedGameData] initMyGuildWithGameGuildData:guildData];
    [[GameDataManager sharedGameData] setYear:_roleData.startYear month:_roleData.startMonth day:_roleData.startDay];
    [[GameDataManager sharedGameData].myGuild gainMoney:_roleData.money];
    
    CityScene *cityScene = [[CityScene alloc] init];
    [[CCDirector sharedDirector] presentScene:cityScene];
    [cityScene changeCity:_roleData.startCityId];
    
    
}

-(void)clickCancelButton
{
    [[CCDirector sharedDirector] popScene];
}

@end
