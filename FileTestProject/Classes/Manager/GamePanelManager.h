//
//  GamePanelManager.h
//  FileTestProject
//
//  Created by LIU YUJIE on 5/7/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogPanel.h"

@interface GamePanelManager : NSObject

+(DialogPanel *)sharedDialogPanelWithDelegate:(id<DialogInteractProtocol>)delegate;

@end
