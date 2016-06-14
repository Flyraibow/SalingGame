//
//  TimePanel.m
//  FileTestProject
//
//  Created by LIU YUJIE on 6/13/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "TimePanel.h"
#import "LocalString.h"

@implementation TimePanel
{
    CCLabelTTF *_labelDay;
}

-(instancetype)init
{
    if (self = [super initWithImageNamed:@"frame_time.png"]) {
        _labelDay = [CCLabelTTF labelWithString:@"" fontName:nil fontSize:14];
        _labelDay.positionType = CCPositionTypeNormalized;
        _labelDay.anchorPoint = ccp(1, 0.5);
        _labelDay.position = ccp(0.80, 0.25);
        [self setDay:0];
        [self addChild:_labelDay];
    }
    return self;
}

-(void)setDay:(int)day
{
    _labelDay.string = [NSString stringWithFormat:getLocalString(@"lab_ship_modify_spend_day"), day];
}
@end
