//
//  InvestPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/1/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "InvestPanel.h"
#import "BGImage.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "GameDataManager.h"
#import "GameCityData.h"
#import "SpendMoneyProtocol.h"

@interface InvestPanel ()

@end

@implementation InvestPanel
{
    CCLabelTTF *_labMoney;
    NSMutableArray *_array;
    int _unitMoney;
    InvestType _type;
    int _selectNum;
    int _maxNum;
}

- (instancetype)initWithDataList:(NSArray *)dataList
{
    if (self = [super init]) {
        
        _type = [dataList[0] integerValue];
        CCNodeColor *node = [BGImage getShadowForBackground];
        node.userInteractionEnabled = NO;
        [self addChild:node];
        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"invest.png"];
        sprite.anchorPoint = ccp(0.5, 0.5);
        sprite.positionType = CCPositionTypeNormalized;
        sprite.position = ccp(0.5, 0.5);
        [self addChild:sprite];
        
        DefaultButton *closeButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_close")];
        [closeButton setTarget:self selector:@selector(clickCloseButton)];
        closeButton.positionType = CCPositionTypeNormalized;
        closeButton.anchorPoint = ccp(1,0);
        closeButton.position = ccp(0.8, 0.03);
        [sprite addChild:closeButton];
        
        DefaultButton *sureButton = [DefaultButton buttonWithTitle:getLocalString(@"lab_sure")];
        [sureButton setTarget:self selector:@selector(clickSureButton)];
        sureButton.positionType = CCPositionTypeNormalized;
        sureButton.anchorPoint = ccp(0,0);
        sureButton.position = ccp(0.2, 0.03);
        [sprite addChild:sureButton];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:getLocalString(@"lab_invest_money") fontName:nil fontSize:12];
        label.positionType = CCPositionTypeNormalized;
        label.position = ccp(0.28, 0.9);
        [sprite addChild:label];
        
        GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:self.cityId];
        if (_type == InvestTypeCommerce) {
            _unitMoney = cityData.commerceValue;
        } else if (_type == InvestTypeMilitary) {
            _unitMoney = cityData.milltaryValue;
        } else  if (_type == InvestTypeSignup) {
            _unitMoney = cityData.signUpUnitValue;
        }
        _labMoney = [CCLabelTTF labelWithString:[@(_unitMoney) stringValue] fontName:nil fontSize:14];
        _labMoney.anchorPoint = ccp(1.0, 0.5);
        _labMoney.positionType = CCPositionTypeNormalized;
        _labMoney.position = ccp(0.85, 0.9);
        [sprite addChild:_labMoney];
        
        _array = [NSMutableArray new];
        for (int i = 0; i < 20; ++i) {
            CCSprite *icon = [CCSprite spriteWithImageNamed:@"money_bag.png"];
            icon.positionType = CCPositionTypeNormalized;
            int x = i % 5;
            int y = i / 5;
            icon.position = ccp(0.177 * x + 0.142, - 0.168 * y + 0.743);
            [sprite addChild:icon];
            if (i) icon.visible = NO;
            [_array addObject:icon];
        }
        _selectNum = 0;
        _maxNum = (int)[GameDataManager sharedGameData].myGuild.money / _unitMoney;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)initWithCityId:(NSString *)cityNo
                   investType:(InvestType)type
{
}

-(void)clickCloseButton
{
    [self removeFromParent];
    if (self.completionBlockWithEventId) {
        self.completionBlockWithEventId(self.cancelEvent);
    }
}

-(void)clickSureButton
{
    int money = _unitMoney * (_selectNum + 1);
    MyGuild *myguild = [GameDataManager sharedGameData].myGuild;
    [myguild spendMoney:money succesHandler:^{
        
        GameCityData *cityData = [[GameDataManager sharedGameData].cityDic objectForKey:self.cityId];
        int money = _unitMoney * (_selectNum + 1);
        [cityData investByGuild:[GameDataManager sharedGameData].myGuild.guildId investUnits:_selectNum + 1 money:money type:_type];
        [self removeFromParent];
        if (self.completionBlockWithEventId) {
            self.completionBlockWithEventId(self.successEvent);
        }
    } failHandle:^{
        [self _setNumber:_maxNum - 1];
    }];
   
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGSize viewSize = [[CCDirector sharedDirector] viewSize];
    CGPoint location = [touch locationInView:[touch view]];
    location.x -= viewSize.width / 2 - 122 ;
    location.y -= viewSize.height / 2 - 91;
    if (location.x > 0 && location.x <= 250 && location.y >= 0 && location.y <= 192) {
        int index = location.x / 50 + (int)(location.y / 48) * 5;
        [self _setNumber:index];
    }
}

-(void)_setNumber:(int)number
{
    if (number >= _maxNum) {
        number = _maxNum - 1;
    }
    _selectNum = number;
    for (int i = 0; i <= number; ++i) {
        CCSprite *icon = [_array objectAtIndex:i];
        icon.visible = YES;
    }
    for (int i = number + 1; i < 20; ++i) {
        CCSprite *icon = [_array objectAtIndex:i];
        icon.visible = NO;
    }
    _labMoney.string = [@(_unitMoney * (number+1)) stringValue];
}

@end
