//
//  GameMapManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapData.h"

@interface GameMapManager : NSObject

+(MapData *)sharedMapData;

@end
