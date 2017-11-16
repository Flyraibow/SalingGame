/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "ActionData.h"
#import "CannonData.h"
#import "CityData.h"
#import "CityBuildingData.h"
#import "ConditionData.h"
#import "DefaultDialogData.h"
#import "EventActionData.h"
#import "GoodsData.h"
#import "GoodsCategoriesData.h"
#import "GuildData.h"
#import "ItemData.h"
#import "NpcData.h"
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

-(CityDic *)getCityDic;

-(CityBuildingDic *)getCityBuildingDic;

-(ConditionDic *)getConditionDic;

-(DefaultDialogDic *)getDefaultDialogDic;

-(EventActionDic *)getEventActionDic;

-(GoodsDic *)getGoodsDic;

-(GoodsCategoriesDic *)getGoodsCategoriesDic;

-(GuildDic *)getGuildDic;

-(ItemDic *)getItemDic;

-(NpcDic *)getNpcDic;

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

