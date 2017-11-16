/* This file is generated, do not modify it !*/
#import "DataManager.h"

static DataManager *_sharedDataManager;

@implementation DataManager
{
	ActionDic *_actionDic;
	CannonDic *_cannonDic;
	CityDic *_cityDic;
	CityBuildingDic *_cityBuildingDic;
	ConditionDic *_conditionDic;
	DefaultDialogDic *_defaultDialogDic;
	EventActionDic *_eventActionDic;
	GoodsDic *_goodsDic;
	GoodsCategoriesDic *_goodsCategoriesDic;
	GuildDic *_guildDic;
	ItemDic *_ItemDic;
	NpcDic *_npcDic;
	RoleInitialDic *_roleInitialDic;
	RouteDic *_routeDic;
	SeaAreaDic *_seaAreaDic;
	SelectListDic *_selectListDic;
	ShipDic *_shipDic;
	ShipStyleDic *_shipStyleDic;
	SkillDic *_skillDic;
	StoryDic *_storyDic;
	StoryTriggerDic *_storyTriggerDic;
	TaskDic *_taskDic;
	TeamDic *_teamDic;
	PriceData *_priceData;
}
-(instancetype)initWithData:(NSData *)data
{
	self = [self init];
	if (self) {
		ByteBuffer *buffer = [[ByteBuffer alloc] initWithData:data];
		_actionDic = [[ActionDic alloc] initWithByteBuffer:buffer];
		_cannonDic = [[CannonDic alloc] initWithByteBuffer:buffer];
		_cityDic = [[CityDic alloc] initWithByteBuffer:buffer];
		_cityBuildingDic = [[CityBuildingDic alloc] initWithByteBuffer:buffer];
		_conditionDic = [[ConditionDic alloc] initWithByteBuffer:buffer];
		_defaultDialogDic = [[DefaultDialogDic alloc] initWithByteBuffer:buffer];
		_eventActionDic = [[EventActionDic alloc] initWithByteBuffer:buffer];
		_goodsDic = [[GoodsDic alloc] initWithByteBuffer:buffer];
		_goodsCategoriesDic = [[GoodsCategoriesDic alloc] initWithByteBuffer:buffer];
		_guildDic = [[GuildDic alloc] initWithByteBuffer:buffer];
		_ItemDic = [[ItemDic alloc] initWithByteBuffer:buffer];
		_npcDic = [[NpcDic alloc] initWithByteBuffer:buffer];
		_roleInitialDic = [[RoleInitialDic alloc] initWithByteBuffer:buffer];
		_routeDic = [[RouteDic alloc] initWithByteBuffer:buffer];
		_seaAreaDic = [[SeaAreaDic alloc] initWithByteBuffer:buffer];
		_selectListDic = [[SelectListDic alloc] initWithByteBuffer:buffer];
		_shipDic = [[ShipDic alloc] initWithByteBuffer:buffer];
		_shipStyleDic = [[ShipStyleDic alloc] initWithByteBuffer:buffer];
		_skillDic = [[SkillDic alloc] initWithByteBuffer:buffer];
		_storyDic = [[StoryDic alloc] initWithByteBuffer:buffer];
		_storyTriggerDic = [[StoryTriggerDic alloc] initWithByteBuffer:buffer];
		_taskDic = [[TaskDic alloc] initWithByteBuffer:buffer];
		_teamDic = [[TeamDic alloc] initWithByteBuffer:buffer];
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
-(ActionDic *)getActionDic
{
	return _actionDic;
}
-(CannonDic *)getCannonDic
{
	return _cannonDic;
}
-(CityDic *)getCityDic
{
	return _cityDic;
}
-(CityBuildingDic *)getCityBuildingDic
{
	return _cityBuildingDic;
}
-(ConditionDic *)getConditionDic
{
	return _conditionDic;
}
-(DefaultDialogDic *)getDefaultDialogDic
{
	return _defaultDialogDic;
}
-(EventActionDic *)getEventActionDic
{
	return _eventActionDic;
}
-(GoodsDic *)getGoodsDic
{
	return _goodsDic;
}
-(GoodsCategoriesDic *)getGoodsCategoriesDic
{
	return _goodsCategoriesDic;
}
-(GuildDic *)getGuildDic
{
	return _guildDic;
}
-(ItemDic *)getItemDic
{
	return _ItemDic;
}
-(NpcDic *)getNpcDic
{
	return _npcDic;
}
-(RoleInitialDic *)getRoleInitialDic
{
	return _roleInitialDic;
}
-(RouteDic *)getRouteDic
{
	return _routeDic;
}
-(SeaAreaDic *)getSeaAreaDic
{
	return _seaAreaDic;
}
-(SelectListDic *)getSelectListDic
{
	return _selectListDic;
}
-(ShipDic *)getShipDic
{
	return _shipDic;
}
-(ShipStyleDic *)getShipStyleDic
{
	return _shipStyleDic;
}
-(SkillDic *)getSkillDic
{
	return _skillDic;
}
-(StoryDic *)getStoryDic
{
	return _storyDic;
}
-(StoryTriggerDic *)getStoryTriggerDic
{
	return _storyTriggerDic;
}
-(TaskDic *)getTaskDic
{
	return _taskDic;
}
-(TeamDic *)getTeamDic
{
	return _teamDic;
}
-(PriceData *)getPriceData
{
	return _priceData;
}

@end

