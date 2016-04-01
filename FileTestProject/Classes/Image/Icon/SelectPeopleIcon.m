//
//  SelectPeopleIcon.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "SelectPeopleIcon.h"
#import "CCSprite+Ext.h"

@implementation SelectPeopleIcon
{
    NSString *_roleId;
}

-(instancetype)initWithRoleId:(NSString *)roleId rolePhotoId:(int)photoId
{
    if (self = [super initWithImageNamed:@"peopleFrame.png"]) {
        _roleId = roleId;
        CCSprite *photo = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"SmallPortrait%d.png", photoId]];
        [photo setRect:CGRectMake(13, 18, 112, 144)];
        [self addChild:photo];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_delegate selectPeople:_roleId];
}

@end
