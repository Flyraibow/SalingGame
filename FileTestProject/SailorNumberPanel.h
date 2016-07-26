//
//  SailorNumberPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 7/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "PopUpFrame.h"

@protocol SailorNumberPanelDelegate <NSObject>

-(void)setSailorNumberFrom:(int)prevSailorNumber toSailorNumber:(int)toSailorNumber;

-(int)getFreeSailorNumbers;

@end

@interface SailorNumberPanel : PopUpFrame

-(instancetype)initWithShipList:(NSArray *)shipList;

-(instancetype)initWithShipList:(NSArray *)shipList freeSailorNumber:(int)freeSailorNumber;

@end
