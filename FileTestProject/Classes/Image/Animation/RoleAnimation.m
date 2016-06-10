//
//  RoleAnimation.m
//  FileTestProject
//
//  Created by LIU YUJIE on 3/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "RoleAnimation.h"
#import "DataManager.h"

static NSMutableDictionary *_sharedActionDictionary;

static int const FRAME_HEIGHT = 48;
static CGFloat const FRAME_INTERVAL = 0.7f;

@implementation RoleAnimation
{
    CCAction *_actionAnimation;
    CGFloat _totalDuration;
    CGFloat _currentDuration;
}


+(NSMutableDictionary *)sharedActionDictionary
{
    if (_sharedActionDictionary == nil) {
        _sharedActionDictionary = [NSMutableDictionary new];
    }
    return _sharedActionDictionary;
}

+(NSArray *)getFrameListForRole:(NSString *)roleId forAction:(ActionType)type
{
    NSMutableDictionary *actionDict = [self sharedActionDictionary];
    NSMutableDictionary *roleActionDict = [actionDict objectForKey:roleId];
    if (roleActionDict == nil) {
        roleActionDict = [NSMutableDictionary new];
        [actionDict setObject:roleActionDict forKey:roleId];
    }
    NSArray *frameList = [roleActionDict objectForKey:@(type)];
    if (frameList == nil) {
        NSMutableArray *frameList1 = [NSMutableArray new];
        NpcData *npcData = [[[DataManager sharedDataManager] getNpcDic] getNpcById:roleId];
        if (npcData != nil) {
            ActionData *actionData = [[[DataManager sharedDataManager] getActionDic] getActionById:[@(type) stringValue]];
            NSString *actionFileName = [NSString stringWithFormat:@"%@_%zd-1.png",npcData.character, actionData.typeId];
            CCTexture *texture = [CCTexture textureWithFile:actionFileName];
            if (texture.contentSize.height > 10)
            {
                int actionNumber = texture.contentSize.height / FRAME_HEIGHT;
                NSArray *actionList;
                if ([actionData.indexList isEqualToString:@"0"]) {
                    actionList = @[@(actionNumber)];
                } else {
                    actionList = [actionData.indexList componentsSeparatedByString:@";"];
                }
                int actionIndex = 0;
                int index = [actionList[actionIndex] intValue];
                for (int i = 0; i < actionNumber; ++i) {
                    CGRect rect = CGRectMake(0, i * FRAME_HEIGHT, texture.contentSize.width, FRAME_HEIGHT);
                    CCSpriteFrame *spriteFrame = [CCSpriteFrame frameWithTexture:texture rectInPixels:rect rotated:NO offset:CGPointMake(0, 0) originalSize:rect.size];
                    CCAnimationFrame *animationFrame = [[CCAnimationFrame alloc] initWithSpriteFrame:spriteFrame delayUnits:FRAME_INTERVAL userInfo:nil];
                    [frameList1 addObject:animationFrame];
                    if (i == index) {
                        ++actionIndex;
                        if (actionIndex == actionList.count) {
                            break;
                        } else {
                            i += [actionList[actionIndex] intValue];
                            actionIndex++;
                            if (actionIndex == actionList.count) {
                                index = actionNumber;
                            } else
                                index = i + [actionList[actionIndex] intValue];
                        }
                    }
                }
                
            }
        }
        frameList = frameList1;
        [actionDict setObject:frameList1 forKey:@(type)];
    }
    return frameList;
}

-(instancetype)initWithRoleId:(NSString *)roleId
{
    if (self = [super init]) {
        _roleId = roleId;
        _loops = YES;
        _stopped = NO;
    }
    return self;
}

-(void)setRoleId:(NSString *)roleId
{
    [self setAction:_action role:roleId];
}

-(void)setAction:(ActionType)action
{
    [self setAction:action role:_roleId];
}

-(void)update:(CCTime)delta
{
    _currentDuration += delta;
    if (_totalDuration > 0) {
        if (_currentDuration >= _totalDuration) {
            _currentDuration -= _totalDuration;
            if (_loops) {
                while (_currentDuration >= _totalDuration) {
                    _currentDuration -= _totalDuration;
                }
            } else {
                [_actionAnimation stop];
                _stopped = YES;
                [self.animationDelegate animationEnds:self];
            }
        }
        
    }
}

-(void)setJob:(NPCJobType)job
{
    if (_job != job) {
        _job = job;
        ActionType actionType = ActionTypeNone;
        switch (job) {
            case NPCJobTypeChef:
                actionType = ActionTypeCooking;
                break;
            case NPCJobTypeDeck:
                actionType = ActionTypeMoping;
                break;
            case NPCJobTypeCannon:
                actionType = ActionTypeLoadingShell;
                break;
            case NPCJobTypeNone:
                actionType = ActionTypeRelaxing;
                break;
            case NPCJobTypeDoctor:
                actionType = ActionTypeMedicating;
                break;
            case NPCJobTypePriest:
                actionType = ActionTypePraying;
                break;
            case NPCJobTypeCaptain:
            case NPCJobTypeThinker:
            case NPCJobTypeAccounter:
            case NPCJobTypeViseCaptain:
            case NPCJobTypeSecondCaptain:
                actionType = ActionTypeLeading;
                break;
            case NPCJobTypeRaiser:
                actionType = ActionTypeFeeding;
                break;
            case NPCJobTypeLookout:
                actionType = ActionTypeObserve;
                break;
            case NPCJobTypeCarpenter:
                actionType = ActionTypeFixing;
                break;
            case NPCJobTypeSteerRoom:
                actionType = ActionTypeHelming;
                break;
            case NPCJobTypeCalibration:
                actionType = ActionTypeMeasuring;
                break;
            case NPCJobTypeChargeCaptain:
                actionType = ActionTypeSwording;
                break;
            case NPCJobTypeOperatingSail:
                actionType = ActionTypePullingSail;
                break;
            case NPCJobTypeRelax:
                actionType = ActionTypeRelaxing;
                break;
        }
        [self setAction:actionType];
    }
}

-(void)setAction:(ActionType)action role:(NSString *)roleId;
{
    if (_action == action && [roleId isEqualToString:_roleId]) {
        if (_stopped) {
            _stopped = NO;
            [_actionAnimation startWithTarget:self];
        }
        return;
    }
    _action = action;
    _roleId = roleId;
    if (_actionAnimation != nil) {
        [self stopAction:_actionAnimation];
    }
    _stopped = NO;
    NSArray *animationList = [RoleAnimation getFrameListForRole:_roleId forAction:action];
    CCAnimation *animation = [[CCAnimation alloc] initWithAnimationFrames:animationList delayPerUnit:FRAME_INTERVAL loops:YES];
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:animation];
    _actionAnimation = [CCActionRepeatForever actionWithAction:animationAction];
    _totalDuration = animation.duration;
    _currentDuration = 0;
    if (animationList.count > 0) {
        self.contentSize = ((CCAnimationFrame *)[animationList objectAtIndex:0]).spriteFrame.rect.size;
    }
    [self runAction:_actionAnimation];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self.delegate selectRoleAnimation:self];
}

@end
