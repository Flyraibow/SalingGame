//
//  SailorNumberPanel.h
//  FileTestProject
//
//  Created by LIU YUJIE on 7/25/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "BasePanel.h"

@protocol SailorNumberPanelDelegate <NSObject>

// 设置该船的新人数，返回true表示成功，false表示设置失败
-(void)setSailorNumberFrom:(int)prevSailorNumber toSailorNumber:(int)toSailorNumber;

-(int)getFreeSailorNumbers;

@end

@interface SailorNumberPanel : BasePanel

@end
