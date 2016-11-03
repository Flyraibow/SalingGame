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
#import "LogicDataData.h"
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
#import "TeamData.h"
#import "ValueSetData.h"

@interface DataManager : NSObject

+(instancetype)dataManagerWithData:(NSData *)data;

+(DataManager *)sharedDataManager;

-(ActionDic*)getActionDic;

-(CannonDic*)getCannonDic;

-(CityDic*)getCityDic;

-(CityBuildingDic*)getCityBuildingDic;

-(ConditionDic*)getConditionDic;

-(DefaultDialogDic*)getDefaultDialogDic;

-(EventActionDic*)getEventActionDic;

-(GoodsDic*)getGoodsDic;

-(GoodsCategoriesDic*)getGoodsCategoriesDic;

-(GuildDic*)getGuildDic;

-(ItemDic*)getItemDic;

-(LogicDataDic*)getLogicDataDic;

-(NpcDic*)getNpcDic;

-(RoleInitialDic*)getRoleInitialDic;

-(RouteDic*)getRouteDic;

-(SeaAreaDic*)getSeaAreaDic;

-(SelectListDic*)getSelectListDic;

-(ShipDic*)getShipDic;

-(ShipStyleDic*)getShipStyleDic;

-(SkillDic*)getSkillDic;

-(StoryDic*)getStoryDic;

-(StoryTriggerDic*)getStoryTriggerDic;

-(TeamDic*)getTeamDic;

-(ValueSetDic*)getValueSetDic;

-(NSDictionary *)getPriceDic;

@end