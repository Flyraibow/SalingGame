//
//  DialogPhotoIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/26/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DialogPhotoIcon.h"
#import "CCSprite+Ext.h"
#import "CCSpriteFrame.h"
#import "CCDirector.h"

@implementation DialogPhotoIcon
{
    CCSprite *_icon;
    CCSprite *_photoFrame;
}

-(instancetype)init
{
    if (self = [super init]) {
        _photoFrame = [CCSprite spriteWithImageNamed:@"photoFrame.png"];
        _photoFrame.positionType = CCPositionTypeNormalized;
        _photoFrame.anchorPoint = ccp(0, 0);
        _photoFrame.position = ccp(0, 0);
        [self addChild:_photoFrame z:1];
        
        _icon = [[CCSprite alloc] init];
        _photoFrame.positionType = CCPositionTypeNormalized;
        _photoFrame.anchorPoint = ccp(0, 0);
        [self addChild:_icon];
        self.visible = NO;
        
        self.scale = [CCDirector sharedDirector].viewSize.height / 2 / _photoFrame.contentSize.height;
    }
    return self;
}

-(void)setPhotoId:(NSString *)photoId
{
    if (photoId == nil || [photoId isEqualToString:@"0"]) {
        self.visible = NO;
    } else {
        self.visible = YES;
        [_icon setSpriteFrame:[CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"dialogPortrait%@.png", photoId]]];
        [_icon setRect:CGRectMake(10, 9, 182, 234)];
    }
}

-(CGSize)size
{
    return CGSizeMake(_photoFrame.contentSize.width * _scaleX, _photoFrame.contentSize.height * _scaleY);
}

@end
