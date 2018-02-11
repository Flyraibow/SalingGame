/* This file is generated, do not modify it !*/
#import "DataManager.h"

static DataManager *_sharedDataManager;

@implementation DataManager
{
	SelectListDic *_selectListDic;
	ConditionDic *_conditionDic;
	JobDic *_jobDic;
	GuildDic *_guildDic;
	CultureDic *_cultureDic;
	StoryDic *_storyDic;
	DefaultDialogDic *_defaultDialogDic;
	NpcInfoDic *_npcInfoDic;
	ItemDic *_ItemDic;
	RoleInitialDic *_roleInitialDic;
	GoodsCategoriesDic *_goodsCategoriesDic;
	NpcDic *_npcDic;
	ShipStyleDic *_shipStyleDic;
	CannonDic *_cannonDic;
	RouteDic *_routeDic;
	GoodsDic *_goodsDic;
	CityDic *_cityDic;
	TaskDic *_taskDic;
	CityBuildingDic *_cityBuildingDic;
	SkillDic *_skillDic;
	CitySystemBarDic *_citySystemBarDic;
	CategoryUpdateDic *_categoryUpdateDic;
	TeamDic *_teamDic;
	ActionDic *_actionDic;
	ShipDic *_shipDic;
	EventActionDic *_eventActionDic;
	StoryTriggerDic *_storyTriggerDic;
	SeaAreaDic *_seaAreaDic;
	PriceData *_priceData;
}
-(instancetype)initWithData:(NSData *)data
{
	self = [self init];
	if (self) {
		ByteBuffer *buffer = [[ByteBuffer alloc] initWithData:data];
		_selectListDic = [[SelectListDic alloc] initWithByteBuffer:buffer];
		_conditionDic = [[ConditionDic alloc] initWithByteBuffer:buffer];
		_jobDic = [[JobDic alloc] initWithByteBuffer:buffer];
		_guildDic = [[GuildDic alloc] initWithByteBuffer:buffer];
		_cultureDic = [[CultureDic alloc] initWithByteBuffer:buffer];
		_storyDic = [[StoryDic alloc] initWithByteBuffer:buffer];
		_defaultDialogDic = [[DefaultDialogDic alloc] initWithByteBuffer:buffer];
		_npcInfoDic = [[NpcInfoDic alloc] initWithByteBuffer:buffer];
		_ItemDic = [[ItemDic alloc] initWithByteBuffer:buffer];
		_roleInitialDic = [[RoleInitialDic alloc] initWithByteBuffer:buffer];
		_goodsCategoriesDic = [[GoodsCategoriesDic alloc] initWithByteBuffer:buffer];
		_npcDic = [[NpcDic alloc] initWithByteBuffer:buffer];
		_shipStyleDic = [[ShipStyleDic alloc] initWithByteBuffer:buffer];
		_cannonDic = [[CannonDic alloc] initWithByteBuffer:buffer];
		_routeDic = [[RouteDic alloc] initWithByteBuffer:buffer];
		_goodsDic = [[GoodsDic alloc] initWithByteBuffer:buffer];
		_cityDic = [[CityDic alloc] initWithByteBuffer:buffer];
		_taskDic = [[TaskDic alloc] initWithByteBuffer:buffer];
		_cityBuildingDic = [[CityBuildingDic alloc] initWithByteBuffer:buffer];
		_skillDic = [[SkillDic alloc] initWithByteBuffer:buffer];
		_citySystemBarDic = [[CitySystemBarDic alloc] initWithByteBuffer:buffer];
		_categoryUpdateDic = [[CategoryUpdateDic alloc] initWithByteBuffer:buffer];
		_teamDic = [[TeamDic alloc] initWithByteBuffer:buffer];
		_actionDic = [[ActionDic alloc] initWithByteBuffer:buffer];
		_shipDic = [[ShipDic alloc] initWithByteBuffer:buffer];
		_eventActionDic = [[EventActionDic alloc] initWithByteBuffer:buffer];
		_storyTriggerDic = [[StoryTriggerDic alloc] initWithByteBuffer:buffer];
		_seaAreaDic = [[SeaAreaDic alloc] initWithByteBuffer:buffer];
		_priceData = [[PriceData alloc] initWithByteBuffer:buffer];
	}
	return self;
}
+(instancetype)dataManagerWithData:(NSData *)data
{
	if (_sharedDataManager == nil) {
		_sharedDataManager = [[DataManager alloc] initWithData:data];
	}
	return _sharedDataManager;
}
+(DataManager *)sharedDataManager
{
	return _sharedDataManager;
}
-(SelectListDic *)getSelectListDic
{
	return _selectListDic;
}
-(ConditionDic *)getConditionDic
{
	return _conditionDic;
}
-(JobDic *)getJobDic
{
	return _jobDic;
}
-(GuildDic *)getGuildDic
{
	return _guildDic;
}
-(CultureDic *)getCultureDic
{
	return _cultureDic;
}
-(StoryDic *)getStoryDic
{
	return _storyDic;
}
-(DefaultDialogDic *)getDefaultDialogDic
{
	return _defaultDialogDic;
}
-(NpcInfoDic *)getNpcInfoDic
{
	return _npcInfoDic;
}
-(ItemDic *)getItemDic
{
	return _ItemDic;
}
-(RoleInitialDic *)getRoleInitialDic
{
	return _roleInitialDic;
}
-(GoodsCategoriesDic *)getGoodsCategoriesDic
{
	return _goodsCategoriesDic;
}
-(NpcDic *)getNpcDic
{
	return _npcDic;
}
-(ShipStyleDic *)getShipStyleDic
{
	return _shipStyleDic;
}
-(CannonDic *)getCannonDic
{
	return _cannonDic;
}
-(RouteDic *)getRouteDic
{
	return _routeDic;
}
-(GoodsDic *)getGoodsDic
{
	return _goodsDic;
}
-(CityDic *)getCityDic
{
	return _cityDic;
}
-(TaskDic *)getTaskDic
{
	return _taskDic;
}
-(CityBuildingDic *)getCityBuildingDic
{
	return _cityBuildingDic;
}
-(SkillDic *)getSkillDic
{
	return _skillDic;
}
-(CitySystemBarDic *)getCitySystemBarDic
{
	return _citySystemBarDic;
}
-(CategoryUpdateDic *)getCategoryUpdateDic
{
	return _categoryUpdateDic;
}
-(TeamDic *)getTeamDic
{
	return _teamDic;
}
-(ActionDic *)getActionDic
{
	return _actionDic;
}
-(ShipDic *)getShipDic
{
	return _shipDic;
}
-(EventActionDic *)getEventActionDic
{
	return _eventActionDic;
}
-(StoryTriggerDic *)getStoryTriggerDic
{
	return _storyTriggerDic;
}
-(SeaAreaDic *)getSeaAreaDic
{
	return _seaAreaDic;
}
-(PriceData *)getPriceData
{
	return _priceData;
}

@end

