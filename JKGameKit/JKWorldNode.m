//
//  JKWorldNode.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKGameScene.h"
#import "JKCameraNode.h"
#import "JKWorldNode.h"

@implementation JKWorldNode

- (void) LoadLevel
{
    self.name = @"WorldNode";
    
    JKCameraNode* camera = [JKCameraNode node];
    camera.name = @"NodeCamera";
    [self addChild:camera];
    self.camera = camera;
}

- (JKHudNode*) loadHUD
{
    JKAssert(NO, @"Child world must implement");
    return nil;
}
@end
