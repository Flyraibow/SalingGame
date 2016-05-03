#import <Foundation/Foundation.h>
#import "ActionData.h"
#import "CityData.h"
#import "CityBuildingData.h"
#import "DefaultDialogData.h"
#import "GoodsData.h"
#import "GoodsCategoriesData.h"
#import "GuildData.h"
#import "ItemData.h"
#import "LogicDataData.h"
#import "NpcData.h"
#import "RoleInitialData.h"
#import "RouteData.h"
#import "SeaAreaData.h"
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

-(CityDic*)getCityDic;

-(CityBuildingDic*)getCityBuildingDic;

-(DefaultDialogDic*)getDefaultDialogDic;

-(GoodsDic*)getGoodsDic;

-(GoodsCategoriesDic*)getGoodsCategoriesDic;

-(GuildDic*)getGuildDic;

-(ItemDic*)getItemDic;

-(LogicDataDic*)getLogicDataDic;

-(NpcDic*)getNpcDic;

-(RoleInitialDic*)getRoleInitialDic;

-(RouteDic*)getRouteDic;

-(SeaAreaDic*)getSeaAreaDic;

-(ShipDic*)getShipDic;

-(ShipStyleDic*)getShipStyleDic;

-(SkillDic*)getSkillDic;

-(StoryDic*)getStoryDic;

-(StoryTriggerDic*)getStoryTriggerDic;

-(TeamDic*)getTeamDic;

-(ValueSetDic*)getValueSetDic;

-(NSDictionary *)getPriceDic;

@end