//
//  DialogPhotoIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/26/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CCSprite.h"

@interface DialogPhotoIcon : CCSprite

@property (nonatomic, readonly) CGSize size;

-(void)setPhotoId:(NSString  *)photoId;

@end
