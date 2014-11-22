//
//  JKWorldNode.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKNode.h"
@class JKCameraNode;
@class JKGameNode;

@interface JKWorldNode : JKNode

@property (nonatomic, weak) JKCameraNode* camera;
@property (nonatomic, weak) JKGameNode* hero;

- (void) LoadLevel;
- (JKHudNode*) loadHUD;

@end
