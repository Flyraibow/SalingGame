//
//  RoleAnimation.h
//  FileTestProject
//
//  Created by LIU YUJIE on 3/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
    ActionTypeNone,
    ActionTypeStanding,
    ActionTypePullingSail,
    ActionTypeObserve,
    ActionTypeMeasuring,
    ActionTypeMoping,
    ActionTypeHelming,
    ActionTypeLeading,
    ActionTypeSwording,
    ActionTypeLoadingShell,
    ActionTypeFixing,
    ActionTypeMedicating,
    ActionTypeCooking,
    ActionTypeRelaxing,
    ActionTypeFeeding,
    ActionTypePraying,
    ActionTypeSpeaking,
    ActionTypeConfusing,
    ActionTypeDying,
    ActionTypeWalking,
    ActionTypeHitting,
    ActionTypeCriticalHitting,
    ActionTypeWouding,
    ActionTypeCount,
} ActionType;

@protocol RoleSelectionProtocol <NSObject>

-(void)selectRoleAnimation:(id)roleAnimation;

@end

@protocol RoleAnimationProtocol <NSObject>

-(void)animationEnds:(id)roleAnimation;

@end

@interface RoleAnimation : CCSprite

@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, assign) ActionType action;
@property (nonatomic, assign) BOOL loops;
@property (nonatomic, assign, readonly) BOOL stopped;
@property (nonatomic) id<RoleSelectionProtocol> delegate;
@property (nonatomic) id<RoleAnimationProtocol> animationDelegate;

-(instancetype)initWithRoleId:(NSString *)roleId;

-(void)setAction:(ActionType)action role:(NSString *)roleId;

@end
