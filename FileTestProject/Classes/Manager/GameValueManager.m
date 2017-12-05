//
//  GameValueManager.m
//  FileTestProject
//
//  Created by Yujie Liu on 11/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "GameValueManager.h"
#import "GameCityData.h"
#import "GameDataManager.h"
#import "LocalString.h"
#import "BaseData.h"
#import "GameItemData.h"
#import "GameTaskData.h"
#import "GameNPCData.h"

static GameValueManager *_sharedValueManager;

@implementation GameValueManager
{
  NSMutableDictionary *_numDictionary;
  NSMutableDictionary *_stringDictionary;
  NSDictionary *_cityDictionary;
  MyGuild *_myguild;
  NSString *_myguildId;
  NSDictionary<NSString *, GameItemData *> *_itemDictionary;
}

+ (void)clearCurrentGame
{
  _sharedValueManager = nil;
}

+ (GameValueManager *)sharedValueManager
{
  if (!_sharedValueManager) {
    _sharedValueManager = [[GameValueManager alloc] init];
  }
  return _sharedValueManager;
}

- (instancetype)init
{
  if (self = [super init]) {
    _numDictionary = [NSMutableDictionary new];
    _stringDictionary = [NSMutableDictionary new];
    _cityDictionary = [GameDataManager sharedGameData].cityDic;
    _itemDictionary = [GameDataManager sharedGameData].itemDic;
    _myguild = [GameDataManager sharedGameData].myGuild;
    _myguildId = _myguild.guildId;
  }
  return self;
}

- (NSInteger)intByKey:(NSString *)key
{
  if ([_numDictionary objectForKey:key]) {
    return [_numDictionary[key] integerValue];
  }
  return -1;
}

- (NSString *)stringByKey:(NSString *)key
{
  id ob = [_stringDictionary objectForKey:key];
  return (ob != [NSNull null]) ? ob : nil;
}

- (void)setString:(NSString *)value byKey:(NSString *)key
{
  [_stringDictionary setObject:value?:[NSNull null] forKey:key];
}

- (void)setNum:(NSInteger)value byKey:(NSString *)key
{
  [_numDictionary setObject:@(value) forKey:key];
}

//for example money=cache.sailorNumber*cache.wage
// contain at most 1 symbol ( +, -, * )
- (void)setNumberByTerm:(NSString *)term
{
  NSArray *array = [term componentsSeparatedByString:@"="];
  NSString *key = array[0];
  NSString *valueStr = array[1];
  NSInteger value;
  if ([valueStr containsString:@"+"]) {
    NSArray *valArray = [valueStr componentsSeparatedByString:@"+"];
    value = [self getNumberByTerm:valArray[0]] + [self getNumberByTerm:valArray[1]];
  } else if ([valueStr containsString:@"-"]) {
    NSArray *valArray = [valueStr componentsSeparatedByString:@"-"];
    value = [self getNumberByTerm:valArray[0]] - [self getNumberByTerm:valArray[1]];
  } else if ([valueStr containsString:@"*"]) {
    NSArray *valArray = [valueStr componentsSeparatedByString:@"*"];
    value = [self getNumberByTerm:valArray[0]] * [self getNumberByTerm:valArray[1]];
  } else {
    value = [self getNumberByTerm:valueStr];
  }
  [self setNum:value byKey:key];
}

- (NSInteger)getNumberByTerm:(NSString *)term
{
  if ([term containsString:@"."]) {
    NSArray *valArr = [term componentsSeparatedByString:@"."];
    NSString *type = valArr[0];
    NSString *subType = valArr[1];
    return [self valueByType:type subType:subType];
  } else {
    return [term integerValue];
  }
}

- (void)setStringByTerm:(NSString *)term
{
  NSArray *array = [term componentsSeparatedByString:@"="];
  NSString *key = array[0];
  NSString *valueStr = array[1];
  [self setString:[self getStringByTerm:valueStr] byKey:key];
}

- (NSString *)getStringByTerm:(NSString *)term
{
  if ([term containsString:@"."]) {
    NSArray *valArr = [term componentsSeparatedByString:@"."];
    NSString *type = valArr[0];
    NSString *subType = valArr[1];
    return [self stringByType:type subType:subType];
  } else {
    return term;
  }
}

- (NSString *)stringByType:(NSString *)type subType:(NSString *)subType
{
  if ([type isEqualToString:@"cache"]) {
    return [self stringByKey:subType];
  } else if ([type isEqualToString:@"city"]) {
    GameCityData *cityData = [_cityDictionary objectForKey:_myguild.myTeam.currentCityId];
    if ([subType isEqualToString:@"unblockItemId"]) {
      return cityData.unblockItemId;
    }
    return [self stringByKey:subType];
  } else if ([type isEqualToString:@"string"]) {
    return subType;
  } else if ([type isEqualToString:@"item"]) {
    if ([subType isEqualToString:@"itemName"]) {
      return getItemName(self.reservedItemData.itemId);
    } else if ([subType isEqualToString:@"itemId"]) {
      return self.reservedItemData.itemId;
    }
  } else if ([type isEqualToString:@"leader"]) {
    SEL selector = NSSelectorFromString(subType);
    return (NSString *)[self performSelector:selector byClass:_myguild.leaderData];
  }
  return type;
}

- (NSInteger)valueByType:(NSString *)type subType:(NSString *)subType
{
  NSInteger value = 0;
  BaseData *data = nil;
  if ([type isEqualToString:@"city"]) {
    data = [_cityDictionary objectForKey:_myguild.myTeam.currentCityId];
  } else if ([type isEqualToString:@"guild"]) {
    data = _myguild;
  } else if ([type isEqualToString:@"team"]) {
    data = _myguild.myTeam;
  } else if ([type isEqualToString:@"cache"]) {
    value = [self intByKey:subType];
  } else if ([type isEqualToString:@"number"]) {
    value = [subType integerValue];
  } else if ([type isEqualToString:@"item"]) {
    data = self.reservedItemData;
  } else if ([type isEqualToString:@"task"]) {
    data = _myguild.taskData;
  }
  if (data) {
    value = [data getValueByType:subType];
  }
  return value;
}

- (id)reservedDataByTerm:(NSString *)term
{
  if ([term isEqualToString:@"role"]) {
    return [GameValueManager sharedValueManager].reservedNPCData;
  } else if ([term isEqualToString:@"item"]) {
    return [GameValueManager sharedValueManager].reservedItemData;
  } else if ([term isEqualToString:@"ship"]) {
    return [GameValueManager sharedValueManager].reservedShipData;
  }
  return nil;
}

-(NSString *)replaceTextWithDefaultRegex:(NSString *)text
{
  NSError *error = nil;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@\\{([^:}]+):([^\\}]+)\\}" options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSTextCheckingResult *match = nil;
  NSUInteger index = 0;
  NSString *finalText = text;
  do{
    match = [regex firstMatchInString:text
                              options:0
                                range:NSMakeRange(index, [text length] - index)];
    if (match) {
      NSRange matchRange = [match range];
      index = matchRange.location + matchRange.length;
      NSRange firstHalfRange = [match rangeAtIndex:1];
      NSRange secondHalfRange = [match rangeAtIndex:2];
      NSString *fullString = [text substringWithRange:matchRange];
      NSString *stringType = [text substringWithRange:firstHalfRange];
      NSString *stringId = [text substringWithRange:secondHalfRange];
      if ([stringType isEqualToString:@"task"]) {
        NSString *substituteString = [_reservedTaskData getStringByType:stringId];
        NSAssert(_reservedTaskData, @"Task cannot be null");
        NSAssert(stringId && stringId.length, @"stringId cannot be empty in task");
        //                NSAssert(substituteString != nil, @"Task fullString (%@), cannot be solved", fullString);
        if (substituteString != nil) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString
                                                           withString:substituteString];
        }
      } else {
        if ([stringId intValue] == 0) {
          stringId = [[GameDataManager sharedGameData] getLogicData:stringId];
        }
        if ([stringType isEqualToString:@"npc"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getNpcFirstName(stringId)];
        } else if([stringType isEqualToString:@"goods"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getGoodsName(stringId)];
        } else if([stringType isEqualToString:@"ship"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getShipsName(stringId)];
        } else if([stringType isEqualToString:@"city"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getCityLabel(stringId)];
        } else if([stringType isEqualToString:@"country"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getCountryName(stringId)];
        } else if([stringType isEqualToString:@"guild"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getGuildName(stringId)];
        } else if([stringType isEqualToString:@"id"]) {
          finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:stringId];
        }
      }
      
    }
  } while (match != nil);
  return finalText;
}

- (id)performSelector:(SEL)aSelector byClass:(Class)cls
{
  NSAssert2([cls respondsToSelector:aSelector], @"class %@ sould be responsible for selector %@", NSStringFromClass(cls),  NSStringFromSelector(aSelector));
  return ((id(*)(id, SEL))[cls methodForSelector:aSelector])(cls, aSelector);
}

@end
