//
//  RouteMarkIcon.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/28/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "RouteMarkIcon.h"
#import "SailMapPanel.h"

@implementation RouteMarkIcon

-(void)clickButton
{
  NSAssert(_delegate != nil, @"delegate cannot be nil");
  
  if (self.type == RouteMarkIconTypeCity) {
    [_delegate clickCity:self.name];
  } else if (self.type == RouteMarkIconTypeShip) {
    [_delegate clickTeam:self.name];
  }
}

@end
