//
//  SailSceneGoProtocol.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#ifndef SailSceneGoProtocol_h
#define SailSceneGoProtocol_h


@protocol SailSceneGoProtocol <NSObject>

-(void)SailSceneGo:(NSString *)cityNo;

@optional
-(void)closeCityPanel;

@end

#endif /* SailSceneGoProtocol_h */
