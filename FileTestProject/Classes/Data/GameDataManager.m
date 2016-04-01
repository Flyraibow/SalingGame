//
//  GameDataManager.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameDataManager.h"

static GameData *_sharedGameData;

@implementation GameDataManager

+(GameData *)sharedGameData
{
    if (_sharedGameData == nil) {
        _sharedGameData = [GameData new];
        [_sharedGameData initGuildData];
    }
    return _sharedGameData;
}

+(NSString *)filePathWithIndex:(int)index
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
     stringByAppendingPathComponent:[NSString stringWithFormat:@"game_data_%d",index]];
}

+(void)saveWithIndex:(int)index
{
    NSString *string = [self filePathWithIndex:index];
    NSLog(@"save: %@", string);
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: _sharedGameData];
    [encodedData writeToFile:string atomically:YES];
}

+(void)loadWithIndex:(int)index
{
    NSString *string = [self filePathWithIndex:index];
    NSLog(@"load: %@", string);
    NSData* decodedData = [NSData dataWithContentsOfFile: string];
    if (decodedData) {
        NSLog(@"load: successful");
        _sharedGameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return;
    }
    _sharedGameData = [[GameData alloc] init];
}

@end
