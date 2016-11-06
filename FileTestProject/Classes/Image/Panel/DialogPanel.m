//
//  DialogPanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "DialogPanel.h"
#import "DataManager.h"
#import "LocalString.h"
#import <objc/message.h>
#import "BaseButtonGroup.h"
#import "DefaultButton.h"
#import "DialogPhotoIcon.h"
#import "GameDataManager.h"
#import "DefaultButton.h"
#import "NSString+Ext.h"
#import "GameNPCData.h"
#import "GameCityData.h"

@implementation DialogPanel
{
    DialogPhotoIcon *_photoIcon;
    CCSprite *_dialogPanel;
    CGSize _contentSize;
    CGSize _windowSize;
    CCLabelTTF *_labelName;
    CCLabelTTF *_labelContent;
    NSArray *_dialogArray;
    NSInteger _index;
    BOOL _selecting;
    CGFloat _basePosX;
    NSArray *_selectedArray;
    BaseButtonGroup *_buttonGroup;
    void(^_handler)(int index);
    void(^_confirmHandler)();
    BOOL _forAllConfirmationFlag;
}

-(instancetype)initWithContentSize:(CGSize)contentSize
{
    if (self = [super init]) {
        _contentSize = contentSize;
        _windowSize = [CCDirector sharedDirector].viewSize;
        
        self.contentSize = _windowSize;
        self.positionType = CCPositionTypeNormalized;
        self.position = ccp(0.5, 0.5);
        self.userInteractionEnabled = YES;
        _forAllConfirmationFlag = NO;
        
        _basePosX = 0.5 - 0.5 / _windowSize.width * contentSize.width;
        _photoIcon = [[DialogPhotoIcon alloc] init];
        _photoIcon.anchorPoint = ccp(0,0);
        _photoIcon.positionType = CCPositionTypeNormalized;
        _photoIcon.position = ccp(_basePosX,0);
        [self addChild:_photoIcon];

        _dialogPanel = [CCSprite spriteWithImageNamed:@"dialogFrame.png"];
        _dialogPanel.positionType = CCPositionTypeNormalized;
        _dialogPanel.scale = (contentSize.width - _photoIcon.size.width) / _dialogPanel.contentSize.width;
        _dialogPanel.anchorPoint = ccp(0, 0);
        _dialogPanel.position = ccp(_basePosX + _photoIcon.size.width / _windowSize.width, 0);
        [self addChild:_dialogPanel];
        _labelName = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:20];
        _labelName.color = [CCColor blackColor];
        _labelName.positionType = CCPositionTypeNormalized;
        _labelName.anchorPoint = ccp(0, 0.5);
        _labelName.position = ccp(0.1, 0.85);
        [_dialogPanel addChild:_labelName];

        _labelContent = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:18 dimensions:CGSizeMake(_dialogPanel.contentSize.width * 0.8 , 100)];
        _labelContent.color = [CCColor blackColor];
        _labelContent.positionType = CCPositionTypeNormalized;
        _labelContent.anchorPoint = ccp(0, 1);
        _labelContent.position = ccp(0.1, 0.75);
        
        _confirmHandler = nil;
        [_dialogPanel addChild:_labelContent];
        _selecting = NO;
        _canRemove = YES;
    }
    return self;
}

-(instancetype)init
{
    CGSize size = [CCDirector sharedDirector].viewSize;
    if (self = [self initWithContentSize:size]) {
        
    }
    return self;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self cutConversation];
}

-(void)cutConversation
{
    if (!_selecting) {
        _canRemove = YES;
        _canShowCoverPanel = YES;
        if (_confirmHandler != nil) _confirmHandler();
        if (_canRemove) {
            [self removeFromParent];
            if (_canShowCoverPanel) {
                self.coverSprite.visible = YES;
            }
        }
    }
}

-(void)clickButton:(DefaultButton *)button
{
    int index = [button.name intValue];
    _canRemove = YES;
    _canShowCoverPanel = YES;
    _handler(index);
    if (_canRemove) {
        [self removeFromParent];
        if (_canShowCoverPanel) {
            self.coverSprite.visible = YES;
        }
    }
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
                finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getCityName(stringId)];
            } else if([stringType isEqualToString:@"country"]) {
                finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getCountryName(stringId)];
            } else if([stringType isEqualToString:@"guild"]) {
                finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:getGuildName(stringId)];
            } else if([stringType isEqualToString:@"id"]) {
                finalText = [finalText stringByReplacingOccurrencesOfString:fullString withString:stringId];
            }
        }
    }while (match != nil);
    return finalText;
}

-(void)setDialogWithPhotoNo:(NSString *)photoNo npcName:(NSString *)npcName text:(NSString *)text
{
    [self setDialogWithPhotoNo:photoNo npcName:npcName text:text handler:(_forAllConfirmationFlag?_confirmHandler:nil)];
}

-(void)setDialogWithPhotoNo:(NSString *)photoNo npcName:(NSString *)npcName text:(NSString *)text handler:(void (^)())handler
{
    _canRemove = NO;
    _confirmHandler = handler;
    if (_buttonGroup != nil) {
        [self removeChild:_buttonGroup];
        _buttonGroup = nil;
        self.userInteractionEnabled = YES;
    }
    [_photoIcon setPhotoId:photoNo];
    if (photoNo != nil && ![photoNo isEqualToString:@"0"]) {
        _dialogPanel.anchorPoint = ccp(0, 0);
        _dialogPanel.position = ccp(_basePosX + _photoIcon.size.width / _windowSize.width, 0);
    } else {
        _dialogPanel.anchorPoint = ccp(0.5, 0);
        _dialogPanel.position = ccp(0.5, 0);
    }
    _labelName.string = npcName;
    _labelContent.string = [self replaceTextWithDefaultRegex:text];
    if (self.coverSprite) {
        if (self.parent != self.coverSprite.scene) {
            [self.coverSprite.scene addChild:self];
        }
        self.coverSprite.visible = !self.hideSprite;
    }
}


-(void)setDialogWithNpcId:(NSString *)npcId text:(NSString *)text
{
    NpcData *npcData = [[[DataManager sharedDataManager] getNpcDic] getNpcById:npcId];
    if (npcId != nil) {
        [self setDialogWithPhotoNo:npcData.dialogPotraitId npcName:getNpcFirstName(npcId) text:text];
    } else {
        [self setDialogWithPhotoNo:@"0" npcName:getNpcFirstName(npcId) text:text];
    }
}

-(void)addYesNoWithCallback:(void(^)(int index))handler
{
    [self addSelections:@[getLocalString(@"lab_yes"), getLocalString(@"lab_no")] callback:handler];
}

-(void)addConfirmHandler:(void(^)())handler
{
    [self addConfirmHandler:handler forAll:NO];
}

-(void)addConfirmHandler:(void(^)())handler forAll:(BOOL)flag
{
    _confirmHandler = handler;
    _forAllConfirmationFlag = flag;
}

-(void)addSelections:(NSArray *)selectArray callback:(void(^)(int index))handler
{
    _handler = handler;
    NSMutableArray *buttonList = [NSMutableArray new];
    for (int i = 0; i < selectArray.count; ++i) {
        NSString *buttonText = [self replaceTextWithDefaultRegex:selectArray[i]];
        DefaultButton *defaultButton = [[DefaultButton alloc] initWithTitle:buttonText];
        defaultButton.name = [@(i) stringValue];
        [defaultButton setTarget:self selector:@selector(clickButton:)];
        [buttonList addObject:defaultButton];
    }
    _buttonGroup = [[BaseButtonGroup alloc] initWithNSArray:buttonList];
    [self addChild:_buttonGroup];
    self.userInteractionEnabled = NO;
}

-(void)setDefaultDialog:(NSString *)defaultDialogId arguments:(NSArray *)arguments
{
    DefaultDialogData *defaultDialogData = [[[DataManager sharedDataManager] getDefaultDialogDic] getDefaultDialogById:defaultDialogId];
    NSString *dialogPhotoId = nil;
    if (defaultDialogData.npcType == 2) {
        int cityStyle = [[DataManager sharedDataManager].getCityDic getCityById:[GameDataManager sharedGameData].myGuild.myTeam.currentCityId].cityStyle;
        if (cityStyle > 0) {
            dialogPhotoId = [NSString stringWithFormat:@"%d_%d", defaultDialogData.npcParameter, cityStyle];
        }
    } else if (defaultDialogData.npcType == 1) {
        dialogPhotoId = [@(defaultDialogData.npcParameter) stringValue];
    } else if (defaultDialogData.npcType == 3) {
        // 先计算出npc的id， 再显示
    } else if (defaultDialogData.npcType == 4) {
        // 船长自己
        dialogPhotoId = [GameDataManager sharedGameData].myGuild.leaderId;
    }
    
    NSString *dialogNameName = @"";
    if (![defaultDialogData.dialogName isEqualToString:@"0"]) {
        dialogNameName = getLocalString(defaultDialogData.dialogName);
    } else if (defaultDialogData.npcType == 4) {
        GameNPCData *npcData = [[GameDataManager sharedGameData].npcDic objectForKey:dialogPhotoId];
        dialogNameName = npcData.fullName;
    }
    
    NSString *dialogText = [NSString stringWithFormat:getLocalString(defaultDialogData.dialogId) arguments:arguments];
    if (!dialogText || dialogText.length == 0) {
        dialogText = [NSString stringWithFormat:@"{%@} dialog not implement yet", defaultDialogId];
    }
    [self setDialogWithPhotoNo:dialogPhotoId npcName:dialogNameName text:dialogText];
}

@end
