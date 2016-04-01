//
//  InvestValueChangeProtocol.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/9/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#ifndef InvestValueChangeProtocol_h
#define InvestValueChangeProtocol_h

@protocol InvestValueChangeProtocol <NSObject>

-(void)commerceValueChange:(int)commerce;
-(void)milltaryValueChange:(int)milltary;

@end

#endif /* InvestValueChangeProtocol_h */
