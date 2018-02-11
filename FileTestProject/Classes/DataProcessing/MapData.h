//
//  MapData.h
//  FileTestProject
//
//  Created by Yujie Liu on 12/25/17.
//  Copyright © 2017 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapData : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) NSArray<NSArray<NSNumber *> *> *mapMatrix;

+(MapData *)mapWithData:(NSData *)data;

@end
