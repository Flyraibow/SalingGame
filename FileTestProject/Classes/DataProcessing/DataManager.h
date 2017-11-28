/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ActionData.h"
#import "CannonData.h"
#import "CategoryUpdateData.h"
#import "CityData.h"
#import "CityBuildingData.h"
#import "CitySystemBarData.h"
#import "ConditionData.h"
#import "CultureData.h"
#import "DefaultDialogData.h"
#import "EventActionData.h"
#import "GoodsData.h"
#import "GoodsCategoriesData.h"
#import "GuildData.h"
#import "ItemData.h"
#import "NpcData.h"
#import "NpcInfoData.h"
#import "RoleInitialData.h"
#import "RouteData.h"
#import "SeaAreaData.h"
#import "SelectListData.h"
#import "ShipData.h"
#import "ShipStyleData.h"
#import "SkillData.h"
#import "StoryData.h"
#import "StoryTriggerData.h"
#import "TaskData.h"
#import "TeamData.h"
#import "PriceData.h"

@interface DataManager : NSObject

-(instancetype)initWithData:(NSData *)data;

+(instancetype)dataManagerWithData:(NSData *)data;

+(DataManager *)sharedDataManager;

-(ActionDic *)getActionDic;

-(CannonDic *)getCannonDic;

-(CategoryUpdateDic *)getCategoryUpdateDic;

-(CityDic *)getCityDic;

-(CityBuildingDic *)getCityBuildingDic;

-(CitySystemBarDic *)getCitySystemBarDic;

-(ConditionDic *)getConditionDic;

-(CultureDic *)getCultureDic;

-(DefaultDialogDic *)getDefaultDialogDic;

-(EventActionDic *)getEventActionDic;

-(GoodsDic *)getGoodsDic;

-(GoodsCategoriesDic *)getGoodsCategoriesDic;

-(GuildDic *)getGuildDic;

-(ItemDic *)getItemDic;

-(NpcDic *)getNpcDic;

-(NpcInfoDic *)getNpcInfoDic;

-(RoleInitialDic *)getRoleInitialDic;

-(RouteDic *)getRouteDic;

-(SeaAreaDic *)getSeaAreaDic;

-(SelectListDic *)getSelectListDic;

-(ShipDic *)getShipDic;

-(ShipStyleDic *)getShipStyleDic;

-(SkillDic *)getSkillDic;

-(StoryDic *)getStoryDic;

-(StoryTriggerDic *)getStoryTriggerDic;

-(TaskDic *)getTaskDic;

-(TeamDic *)getTeamDic;

-(PriceData *)getPriceData;

@end

