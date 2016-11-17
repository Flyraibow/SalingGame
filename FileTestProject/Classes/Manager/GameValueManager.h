//
//  GameValueManager.h
//  FileTestProject
//
//  Created by Yujie Liu on 11/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *ReservedItem = @"itemId";

@interface GameValueManager : NSObject

+ (GameValueManager *)sharedValueManager;

- (NSString *)stringByKey:(NSString *)key;

- (NSString *)reservedStringByKey:(const NSString *)key;

- (NSInteger)intByKey:(NSString *)key;

- (void)setString:(NSString *)value byKey:(NSString *)key;

- (void)setReserveString:(NSString *)value byKey:(const NSString *)key;

- (void)setNum:(NSInteger)value byKey:(NSString *)key;

- (void)setNumberByTerm:(NSString *)term;

- (void)setStringByTerm:(NSString *)term;

- (NSInteger)getNumberByTerm:(NSString *)term;

- (NSString *)getStringByTerm:(NSString *)term;

- (NSInteger)valueByType:(NSString *)type subType:(NSString *)subType;

- (NSString *)stringByType:(NSString *)type subType:(NSString *)subType;


@end
