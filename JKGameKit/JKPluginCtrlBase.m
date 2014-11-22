//
//  JKPluginCtrlBase.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKPluginCtrlBase.h"

@implementation JKPluginCtrlBase

- (instancetype) initWithNode:(SKNode<JKNodeProtocol> *)node
{
    if (self = [super initWithNode:node])
    {
        _startPosition = node.position;
        _startRotation = node.zRotation;
    }
    return self;
}

- (void) onGameBegin
{
    self.node.position = self.startPosition;
    self.node.zRotation = self.startRotation;
}

+ (instancetype) createAndAttachToNode:(SKNode *)node
{
    return [[self class] createAndAttachToNode:node Key:PLUGIN_KEY_CONTROLLER];
}
@end
