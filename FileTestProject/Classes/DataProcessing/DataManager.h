/* This file is generated, do not modify it !*/

#import <Foundation/Foundation.h>
#import "SelectListData.h"
#import "ConditionData.h"
#import "JobData.h"
#import "GuildData.h"
#import "CultureData.h"
#import "StoryData.h"
#import "DefaultDialogData.h"
#import "NpcInfoData.h"
#import "ItemData.h"
#import "RoleInitialData.h"
#import "GoodsCategoriesData.h"
#import "NpcData.h"
#import "ShipStyleData.h"
#import "CannonData.h"
#import "RouteData.h"
#import "GoodsData.h"
#import "CityData.h"
#import "TaskData.h"
#import "CityBuildingData.h"
#import "SkillData.h"
#import "CitySystemBarData.h"
#import "CategoryUpdateData.h"
#import "TeamData.h"
#import "ActionData.h"
#import "ShipData.h"
#import "EventActionData.h"
#import "StoryTriggerData.h"
#import "SeaAreaData.h"
#import "PriceData.h"


@interface DataManager : NSObject

-(instancetype)initWithData:(NSData *)data;

+(instancetype)dataManagerWithData:(NSData *)data;

+(DataManager *)sharedDataManager;

-(SelectListDic *)getSelectListDic;

-(ConditionDic *)getConditionDic;

-(JobDic *)getJobDic;

-(GuildDic *)getGuildDic;

-(CultureDic *)getCultureDic;

-(StoryDic *)getStoryDic;

-(DefaultDialogDic *)getDefaultDialogDic;

-(NpcInfoDic *)getNpcInfoDic;

-(ItemDic *)getItemDic;

-(RoleInitialDic *)getRoleInitialDic;

-(GoodsCategoriesDic *)getGoodsCategoriesDic;

-(NpcDic *)getNpcDic;

-(ShipStyleDic *)getShipStyleDic;

-(CannonDic *)getCannonDic;

-(RouteDic *)getRouteDic;

-(GoodsDic *)getGoodsDic;

-(CityDic *)getCityDic;

-(TaskDic *)getTaskDic;

-(CityBuildingDic *)getCityBuildingDic;

-(SkillDic *)getSkillDic;

-(CitySystemBarDic *)getCitySystemBarDic;

-(CategoryUpdateDic *)getCategoryUpdateDic;

-(TeamDic *)getTeamDic;

-(ActionDic *)getActionDic;

-(ShipDic *)getShipDic;

-(EventActionDic *)getEventActionDic;

-(StoryTriggerDic *)getStoryTriggerDic;

-(SeaAreaDic *)getSeaAreaDic;

-(PriceData *)getPriceData;

@end

