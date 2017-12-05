//
//  RouteMarkIcon.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/28/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

@protocol SailMapPanelDelegate;

typedef enum : NSUInteger {
  RouteMarkIconTypeCity,
  RouteMarkIconTypeShip,
  RouteMarkIconTypeVillage,
} RouteMarkIconType;

@interface RouteMarkIcon : CCButton

@property (nonatomic, assign) RouteMarkIconType type;

@property (nonatomic, copy) NSString *buttonLabel;

@property (nonatomic, weak) id<SailMapPanelDelegate> delegate;

-(void)clickButton;

@end
