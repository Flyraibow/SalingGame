//
//  GameDataManager.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/2/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameDataManager.h"

static NSString * const GAME_CODE_PROGRESS = @"progress";
static GameData *_sharedGameData;
static GameProgressData *_sharedGameProgressData;


static NSString* filePathWithString(NSString *string)
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:string];
}

static NSString* filePathWithIndex(int index)
{
    return filePathWithString([NSString stringWithFormat:@"game_data_%d",index]);
}

@interface GameProgressData() <NSCoding>

@end

@implementation GameProgressData
{
    NSMutableDictionary *_dictionary;
}

- (instancetype)init
{
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_dictionary forKey:@"dictionary"];
}

- (NSString *)descriptionForIndex:(int)index
{
    return [_dictionary objectForKey:@(index)];
}

- (void)saveDestription:(NSString *)desc forIndex:(int)index
{
    [_dictionary setObject:desc forKey:@(index)];
}

@end

@implementation GameDataManager

+(GameData *)sharedGameData
{
    if (_sharedGameData == nil) {
        _sharedGameData = [GameData new];
        [_sharedGameData initGuildData];
    }
    return _sharedGameData;
}

+(GameProgressData *)sharedProgressData
{
    if (_sharedGameProgressData == nil) {
        // load progress
        NSData* decodedData = [NSData dataWithContentsOfFile:filePathWithString(GAME_CODE_PROGRESS)];
        if (decodedData) {
            NSLog(@"load progress: successful");
            _sharedGameProgressData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        } else  {
            _sharedGameProgressData = [[GameProgressData alloc] init];
        }
    }
    return _sharedGameProgressData;
}

+(void)saveWithIndex:(int)index
{
    NSString *string = filePathWithIndex(index);
    NSLog(@"save: %@", string);
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: _sharedGameData];
    [encodedData writeToFile:string atomically:YES];

    // save progress
    [_sharedGameProgressData saveDestription:[_sharedGameData description] forIndex:index];
    encodedData = [NSKeyedArchiver archivedDataWithRootObject: _sharedGameProgressData];
    [encodedData writeToFile:filePathWithString(GAME_CODE_PROGRESS) atomically:YES];
}

+(void)loadWithIndex:(int)index
{
    NSString *string = filePathWithIndex(index);
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
