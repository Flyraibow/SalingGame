//
//  SelectPeopleIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@protocol PeopleIconSelectionDelegate <NSObject>

-(void)selectPeople:(NSString *)roleId;

@end

@interface SelectPeopleIcon : CCSprite

@property (nonatomic) id<PeopleIconSelectionDelegate> delegate;

-(instancetype)initWithRoleId:(NSString *)roleId rolePhotoId:(int)photoId;

@end
