//
//  HelloWorldScene.m
//
//  Created by : LIU YUJIE
//  Project    : FileTestProject
//  Date       : 1/27/16
//
//  Copyright (c) 2016 Yujie Liu.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"
#import "DataManager.h"
#import "MenuPage.h"
#import "BGImage.h"
#import "GameRouteData.h"
#import "GameStoryTriggerManager.h"
// -----------------------------------------------------------------------

@implementation HelloWorldScene

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    // Background
    CGSize contentSize = [CCDirector sharedDirector].viewSize;
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = contentSize;
    background.color = [CCColor grayColor];
    [self addChild:background];
    
    // The standard Hello World text
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Loading" fontName:@"ArialMT" fontSize:64];
    label.positionType = CCPositionTypeNormalized;
    label.position = (CGPoint){0.5, 0.5};
    [self addChild:label];
    
    [BGImage initWithGroundSize:contentSize];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource: @"game" ofType: @"dat"];
    NSData *myData = [NSData dataWithContentsOfFile:thePath];
    DataManager *dataManager = [DataManager dataManagerWithData:myData];
//    [GameRouteData initWithRouteDic:dataManager.getRouteDic];
  
    [self schedule:@selector(loadComplete) interval:0.2f];
    
    // done
    return self;
}

-(void)loadComplete
{
    [[CCDirector sharedDirector] presentScene:[MenuPage new]];
}

// -----------------------------------------------------------------------

@end























// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
