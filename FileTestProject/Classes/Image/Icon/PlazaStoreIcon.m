//
//  PlazaStoreIcon.m
//  FileTestProject
//
//  Created by Yujie Liu on 12/20/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import "PlazaStoreIcon.h"
#import "DataManager.h"

@implementation PlazaStoreIcon

- (instancetype)initWithCultureId:(NSString *)cultureId
{
  CultureData *cultureData = [[[DataManager sharedDataManager] getCultureDic] getCultureById:cultureId];
  if (self = [super initWithImageNamed:cultureData.PlazaStore]) {
    
  }
  return self;
}

@end
