//
//  CGStoryScene.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/10/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "CGStoryScene.h"
#import "BGImage.h"
#import "DataManager.h"
#import "LocalString.h"
#import "DialogPanel.h"
#import "GameDataManager.h"
#import "DuelScene.h"

typedef enum : NSUInteger {
    StoryCommandTypeNone,
    StoryCommandTypeAddPhoto,
    StoryCommandTypePhotoAnchor,
    StoryCommandTypePhotoMove,
    StoryCommandTypePhotoScale,
    StoryCommandTypePhotoAlpha,
    StoryCommandTypeRemovePhoto,
    StoryCommandTypeWaitTime,
    StoryCommandTypeWaitClick,
    StoryCommandTypePlayBGM,
    StoryCommandTypePlaySE,
    StoryCommandTypeStopBGM,
    StoryCommandTypeShowDialog,
    StoryCommandTypeShowText,
    StoryCommandTypeCloseText,
    StoryCommandTypeShowDialogSelection,
    StoryCommandTypeChangeLogicData,
    StoryCommandTypeSpecial,
    StoryCommandTypeDuel,
} StoryCommandType;

@interface StoryActionData : NSObject

@property (nonatomic) BOOL finished;

-(instancetype)initWithSprite:(CCSprite *)sprite moveTo:(CGPoint)point time:(CGFloat)time;
-(instancetype)initWithSprite:(CCSprite *)sprite scaleTo:(CGFloat)scale time:(CGFloat)time;
-(instancetype)initWithSprite:(CCSprite *)sprite alphaTo:(CGFloat)alpha time:(CGFloat)time;

@end

@implementation StoryActionData
{
    CGFloat _currentTime;
    CGFloat _totalTime;
    CCSprite *_sprite;
    CGPoint _currentPoint;
    CGPoint _destinationPoint;
    StoryCommandType _type;
    CGFloat _scaleTo;
    CGFloat _currentScale;
    CGFloat _alphaTo;
    CGFloat _currentAlpha;
}


-(instancetype)initWithSprite:(CCSprite *)sprite time:(CGFloat)time
{
    if (self = [super init]) {
        _sprite = sprite;
        _totalTime = time;
        _currentTime = 0;
    }
    
    return self;
}

-(instancetype)initWithSprite:(CCSprite *)sprite moveTo:(CGPoint)point time:(CGFloat)time
{
    if (self = [self initWithSprite:sprite time:time]) {
        _currentPoint = sprite.position;
        _destinationPoint = point;
        _type = StoryCommandTypePhotoMove;
    }
    
    return self;
}

-(instancetype)initWithSprite:(CCSprite *)sprite scaleTo:(CGFloat)scale time:(CGFloat)time
{
    if (self = [self initWithSprite:sprite time:time]) {
        _scaleTo = scale;
        _currentScale = sprite.scale;
        _type = StoryCommandTypePhotoScale;
    }
    
    return self;
}

-(instancetype)initWithSprite:(CCSprite *)sprite alphaTo:(CGFloat)alpha time:(CGFloat)time
{
    if (self = [self initWithSprite:sprite time:time]) {
        _alphaTo = alpha;
        _currentAlpha  = sprite.opacity;
        _type = StoryCommandTypePhotoAlpha;
    }
    
    return self;
}

-(void)update:(CGFloat)delta
{
    _currentTime += delta;
    if (_currentTime > _totalTime) {
        _currentTime = _totalTime;
        _finished = YES;
    }
    CGFloat scale = _currentTime / _totalTime;
    if (_type == StoryCommandTypePhotoMove) {
        _sprite.position = ccp(_currentPoint.x + (_destinationPoint.x - _currentPoint.x) * scale, _currentPoint.y + (_destinationPoint.y - _currentPoint.y) * scale);
    } else if (_type == StoryCommandTypePhotoScale) {
        _sprite.scale = _currentScale + (_scaleTo - _currentScale) * scale;
    } else if (_type == StoryCommandTypePhotoAlpha) {
        _sprite.opacity = _currentAlpha + (_alphaTo - _currentAlpha) * scale;
    }
}

@end

@interface CGStoryScene() <DialogInteractProtocol, DuelSceneDelegate>

@end

@implementation CGStoryScene
{
    NSArray *_storyList;
    BOOL _running;
    BOOL _waitingClick;
    NSInteger _currentIndex;
    NSMutableDictionary *_photoDict;
    NSMutableSet *_actionSet;
    CGFloat _waitTime;
    CGSize _contentSize;
    CCLabelTTF *_text;
    DialogPanel *_dialogPanel;
    BOOL _inDialog;
    BOOL _selectinDialog;
    CGFloat _touchTime;
    NSArray *_selectionResult;
    NSString *_storyId;
    NSString *_duelResult;
}

-(instancetype)initWithStoryId:(NSString *)storyId
{
    if (self = [super init]) {
        _storyId = storyId;
        _contentSize = [CCDirector sharedDirector].viewSize;
        CCSprite *coverSprite = [CCSprite spriteWithImageNamed:@"CG_Bg.png"];
        coverSprite.scale = _contentSize.height / coverSprite.contentSize.height;
        coverSprite.positionType = CCPositionTypeNormalized;
        coverSprite.position = ccp(0.5, 0.5);
        [self addChild:coverSprite z:100];
        
        _storyList = [[[DataManager sharedDataManager] getStoryDic] getStoryGroupByGroupId:storyId];
        _running = NO;
        _waitingClick = NO;
        _inDialog = NO;
        _selectinDialog = NO;
        self.userInteractionEnabled = YES;
        
        _photoDict = [NSMutableDictionary new];
        _actionSet = [NSMutableSet new];
        _text = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:20];
        _text.anchorPoint = ccp(0, 0);
        _text.positionType = CCPositionTypeNormalized;
        CGFloat posX = - 0.45 / _contentSize.width * (_contentSize.height * 4 / 3) + 0.5;
        _text.position = ccp(posX, 0.05);
        [self addChild:_text z:101];
        _touchTime = 0;
    }
    return self;
}

-(void)runStory
{
    _running = YES;
    [[GameDataManager sharedGameData].myGuild addStoryId:_storyId];
}

-(void)update:(CCTime)delta
{
    if (_running) {
        if (_touchTime > 0) {
            _touchTime += delta;
        }
        if (_waitTime > 0 || _waitingClick || _inDialog) {
            if (_selectinDialog == NO && _touchTime > 2) {
                // speed up
                delta = 5;
                _waitingClick = NO;
                if (_inDialog) {
                    [self confirm];
                }
            }
            if (_waitTime > 0 ) {
                _waitTime -= delta;
            }
            NSMutableSet *removeSet = [NSMutableSet new];
            for (StoryActionData *actionData in _actionSet) {
                [actionData update:delta];
                if (actionData.finished) {
                    [removeSet addObject:actionData];
                }
            }
            for (StoryActionData *actionData in removeSet) {
                [_actionSet removeObject:actionData];
            }
        }
        else {
            BOOL flag = YES;
            while (_currentIndex < _storyList.count && flag) {
                StoryData *storyData = [_storyList objectAtIndex:_currentIndex++];
                switch (storyData.command) {
                    case StoryCommandTypeAddPhoto:
                    {
                        //photoId, photoNo, level , scale mode
                        CCSprite *sprite = [CCSprite spriteWithImageNamed:storyData.parameter2];
                        sprite.positionType = CCPositionTypeNormalized;
                        sprite.position = ccp(0.5, 0.5);
                        if ([storyData.parameter4 intValue] == 1) {
                            sprite.scale = _contentSize.height / sprite.contentSize.height;
                        }
                        [_photoDict setObject:sprite forKey:storyData.parameter1];
                        [self addChild:sprite z:[storyData.parameter3 intValue]];
                        break;
                    }
                    case StoryCommandTypePhotoAnchor:
                    {
                        //photoId; anchorType 0 :normalized, 1:points; anchor posX, posY
                        CCSprite *sprite = [_photoDict objectForKey:storyData.parameter1];
                        if ([storyData.parameter2 intValue] == 1) {
                            sprite.positionType = CCPositionTypePoints;
                        } else {
                            sprite.positionType = CCPositionTypeNormalized;
                        }
                        sprite.anchorPoint = ccp([storyData.parameter3 doubleValue], [storyData.parameter4 doubleValue]);
                        break;
                    }
                    case StoryCommandTypePhotoMove:
                    {
                        //photoId, posX ,posY, time
                        CCSprite *sprite = [_photoDict objectForKey:storyData.parameter1];
                        double time = [storyData.parameter4 doubleValue];
                        //所有的坐标都以相框作为对比，高不变，宽做挑战。
                        double posX = [storyData.parameter2 doubleValue];
                        double posY = [storyData.parameter3 doubleValue];
                        if (sprite.positionType.corner == CCPositionTypeNormalized.corner) {
                            posX = (posX - 0.5) / _contentSize.width * (_contentSize.height * 4 / 3) + 0.5;
                        } else {
                            posX += _contentSize.width / 2;
                            posY += _contentSize.height / 2;
                        }
                        CGPoint moveTo = ccp(posX,posY);
                        if (time == 0) {
                            sprite.position = moveTo;
                        } else {
                            StoryActionData *actionData = [[StoryActionData alloc] initWithSprite:sprite moveTo:moveTo time:time];
                            [_actionSet addObject:actionData];
                        }
                        break;
                    }
                    case StoryCommandTypePhotoScale:
                    {
                        CCSprite *sprite = [_photoDict objectForKey:storyData.parameter1];
                        double time = [storyData.parameter3 doubleValue];
                        CGFloat scale = [storyData.parameter2 doubleValue];
                        if ([storyData.parameter4 intValue] == 1) {
                            scale *= _contentSize.height / sprite.contentSize.height;
                        }
                        if (time == 0) {
                            sprite.scale = scale;
                        } else {
                            StoryActionData *actionData = [[StoryActionData alloc] initWithSprite:sprite scaleTo:scale time:time];
                            [_actionSet addObject:actionData];
                        }
                        break;
                    }
                    case StoryCommandTypePhotoAlpha:
                    {
                        CCSprite *sprite = [_photoDict objectForKey:storyData.parameter1];
                        double time = [storyData.parameter3 doubleValue];
                        CGFloat opacity = [storyData.parameter2 doubleValue];
                        if (time == 0) {
                            sprite.opacity = opacity;
                        } else {
                            StoryActionData *actionData = [[StoryActionData alloc] initWithSprite:sprite alphaTo:opacity time:time];
                            [_actionSet addObject:actionData];
                        }
                        break;
                    }
                    case StoryCommandTypeRemovePhoto:
                    {
                        CCSprite *sprite = [_photoDict objectForKey:storyData.parameter1];
                        [self removeChild:sprite];
                        [_photoDict removeObjectForKey:sprite];
                        break;
                    }
                    case StoryCommandTypeWaitTime:
                    {
                        _waitTime = [storyData.parameter1 doubleValue];
                        flag = NO;
                        break;
                    }
                    case StoryCommandTypeWaitClick:
                    {
                        _waitingClick = YES;
                        flag = NO;
                        break;
                    }
                    case StoryCommandTypePlayBGM:
                    {
                        [[OALSimpleAudio sharedInstance] playBg:storyData.parameter1 loop:[storyData.parameter2 intValue] == 0];
                        break;
                    }
                    case StoryCommandTypePlaySE:
                    {
                        [[OALSimpleAudio sharedInstance] playEffect:storyData.parameter1];
                        break;
                    }
                    case StoryCommandTypeStopBGM:
                    {
                        [[OALSimpleAudio sharedInstance] stopBg];
                        break;
                    }
                    case StoryCommandTypeShowDialog:
                    {
                        if (_dialogPanel == nil) {
                            _dialogPanel = [[DialogPanel alloc] initWithContentSize:CGSizeMake(_contentSize.height / 3 * 4, _contentSize.height)];
                            _dialogPanel.delegate = self;
                        }
                        [self addChild:_dialogPanel z:102];
                        NSString *npcName;
                        if ([storyData.parameter2 isEqualToString:@"0"]) {
                            npcName = @"";
                        } else {
                            npcName = getNpcFirstName(storyData.parameter2);
                        }
                        [_dialogPanel setDialogWithPhotoNo:storyData.parameter1 npcName:npcName text:getStoryText(storyData.parameter3)];
                        _inDialog = YES;
                        flag = NO;
                        // if the dialog has selections ,load immediately
                        BOOL selectionsFlag = ([storyData.parameter4 intValue] > 0);
                        if (selectionsFlag) {
                            StoryData *storyData1 = [_storyList objectAtIndex:_currentIndex];
                            if (storyData1.command == StoryCommandTypeShowDialogSelection) {
                                NSArray *selections = [getStorySelectionText(storyData1.parameter1) componentsSeparatedByString:@";"];
                                [_dialogPanel addSelections:selections];
                                _selectionResult = [storyData1.parameter2 componentsSeparatedByString:@";"];
                                _selectinDialog = YES;
                                _currentIndex++;
                            }
                        }
                        break;
                    }
                    case StoryCommandTypeShowText:
                    {
                        _text.string = getStoryText(storyData.parameter1);
                        break;
                    }
                    case StoryCommandTypeCloseText:
                    {
                        _text.string = @"";
                        break;
                    }
                    case StoryCommandTypeChangeLogicData:
                    {
                        NSString *logicId = storyData.parameter1;
                        NSString *value;
                        if ([storyData.parameter4 intValue] == 1) {
                            value = [[GameDataManager sharedGameData] getLogicData:storyData.parameter3];
                        } else {
                            value = storyData.parameter3;
                        }
                        
                        ChangeValueType valueChangeType = [storyData.parameter2 intValue];
                        [[GameDataManager sharedGameData] setLogicDataWithLogicId:logicId value:value changeValueType:valueChangeType];
                        break;
                    }
                    case StoryCommandTypeSpecial:
                    {
                        [[GameDataManager sharedGameData] setSpecialLogical:storyData.parameter1 parameter2:storyData.parameter2 parameter3:storyData.parameter3 parameter4:storyData.parameter4];
                        break;
                    }
                    case StoryCommandTypeDuel:
                    {
                        _waitingClick = YES;
                        flag = NO;
                        NSString *heroId = [storyData.parameter1 componentsSeparatedByString:@";"][0];
                        NSString *enemyId = [storyData.parameter1 componentsSeparatedByString:@";"][1];
                        _duelResult = storyData.parameter2;
                        DuelScene *duelScene = [[DuelScene alloc] initWithRoleId:heroId roleId:enemyId];
                        duelScene.delegate = self;
                        [[CCDirector sharedDirector] pushScene:duelScene];
                        break;
                    }
                    default:
                        break;
                }
            }
            if (flag && _currentIndex >= _storyList.count) {
                [[CCDirector sharedDirector] popScene];
                [self.delegate storyEnd];
            }
        }
    }
}

-(void)duelEnds:(DuelResult)result
{
    NSString *storyId;
    if (result == DuelResultWin) {
        storyId = [_duelResult componentsSeparatedByString:@";"][0];
    } else {
        storyId = [_duelResult componentsSeparatedByString:@";"][1];
    }
    if (![storyId isEqualToString:@"0"]) {
        [self gotoStory:storyId];
    }
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    _touchTime = 1;
    if (_waitingClick) {
        _waitingClick = NO;
    }
}

-(void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    _touchTime = 0;
}

-(void)confirm
{
    [self removeChild:_dialogPanel];
    _inDialog = NO;
}

-(void)selectIndex:(int)index
{
    NSString *selectStoryId = [_selectionResult objectAtIndex:index];
    if ([selectStoryId isEqualToString:@"0"]) {
        _selectinDialog = NO;
        _inDialog = NO;
        [self removeChild:_dialogPanel];
    } else {
        // goto Story Id:
        [self gotoStory:selectStoryId];
    }
}

-(void)gotoStory:(NSString *)storyId
{
    CGStoryScene *storyScene = [[CGStoryScene alloc] initWithStoryId:storyId];
    storyScene.delegate = self.delegate;
    [[CCDirector sharedDirector] presentScene:storyScene];
    [storyScene runStory];
}

@end
