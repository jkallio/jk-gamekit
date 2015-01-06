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
#import "JKGameNode.h"
#import "JKWorldNode.h"

@implementation JKWorldNode

- (void) loadLevel
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

- (JKGameNode*) hero
{
    if (!_hero)
    {
        _hero = [JKGameNode cast:[self childNodeWithName:NODE_NAME_HERO]];
    }
    return _hero;
}
@end
