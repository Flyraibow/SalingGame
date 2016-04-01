//
//  SailSceneShipProtocol.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/14/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#ifndef SailSceneShipProtocol_h
#define SailSceneShipProtocol_h

typedef enum : NSUInteger {
    SailTypeToCity,
    SailTypeToSearch,
} SailType;


@protocol SailSceneShipProtocol <NSObject>

-(void)reachDestinationCity:(NSString *)cityId;

-(void)changeSeaArea:(NSString *)seaId;

@end

#endif /* SailSceneShipProtocol_h */
