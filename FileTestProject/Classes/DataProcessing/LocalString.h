//
//  LocalString.h
//  FileTestProject
//
//  Created by LIU YUJIE on 1/31/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#ifndef LocalString_h
#define LocalString_h

#import <Foundation/Foundation.h>
static NSString* getLocalString(NSString *str)
{
    return NSLocalizedString(str, nil);
}

static NSString* getLocalStringByInt(NSString *str,int value)
{
    NSString *string = [NSString stringWithFormat:@"%@%d",str,value];
    return NSLocalizedString(string, nil);
}

static NSString* getLocalStringByString(NSString *str,NSString *value)
{
    NSString *string = [NSString stringWithFormat:@"%@%@",str,value];
    return NSLocalizedString(string, nil);
}

static NSString* getNpcFirstName(NSString *npcId)
{
    return getLocalStringByString(@"npc_firstname_", npcId);
}

static NSString* getNpcLastName(NSString *npcId)
{
    return getLocalStringByString(@"npc_lastname_", npcId);
}

static NSString* getNpcFullName(NSString *npcId)
{
    return [NSString stringWithFormat:@"%@ %@", getNpcFirstName(npcId), getNpcLastName(npcId)] ;
}

static NSString* getCityNpcName(int *npcId)
{
    return getLocalStringByInt(@"city_npc_name_", npcId);
}

static NSString* getGoodsName(NSString *goodsId)
{
    return getLocalStringByString(@"goods_name_", goodsId);
}

static NSString* getShipsName(NSString *shipId)
{
    return getLocalStringByString(@"ship_name_", shipId);
}

static NSString* getCityName(NSString *cityId)
{
    return getLocalStringByString(@"city_name_", cityId);
}

static NSString* getCountryName(NSString *countryId)
{
    return getLocalStringByString(@"city_country_", countryId);
}

static NSString* getGuildName(NSString *guildId)
{
    return getLocalStringByString(@"guild_name_", guildId);
}

static NSString* getNpcDescription(NSString *npcId)
{
    return getLocalStringByString(@"npc_description_", npcId);
}

static NSString* getStoryText(NSString *textId)
{
    return getLocalStringByString(@"story_text_", textId);
}

static NSString* getDialogText(NSString *dialogId)
{
    return getLocalStringByString(@"dialog_", dialogId);
}

static NSString* getItemName(NSString *itemId)
{
    return getLocalStringByString(@"item_name_", itemId);
}

static NSString* getItemType(int itemType)
{
    return getLocalStringByInt(@"item_type_", itemType);
}

static NSString* getItemDescription(NSString *itemId)
{
    return getLocalStringByString(@"item_description_", itemId);
}

static NSString* getGoodsDescription(NSString *goodsId)
{
    return getLocalStringByString(@"goods_description_", goodsId);
}

static NSString* getCannonName(int cannonPower)
{
    return getLocalStringByInt(@"cannon_name_", cannonPower);
}

static NSString* getCannonDescription(int cannonPower)
{
    return getLocalStringByInt(@"cannon_description_", cannonPower);
}

static NSString* getNumber(NSInteger number)
{
  return [@(number) stringValue];
}

#endif /* LocalString_h */
