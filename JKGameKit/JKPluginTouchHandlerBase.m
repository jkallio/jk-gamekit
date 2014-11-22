//
//  PluginTouchHandlerBase.m
//  GigaMan
//
//  Created by Jussi Kallio on 6.10.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKPluginTouchHandlerBase.h"

@implementation JKPluginTouchHandlerBase

- (void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSAssert(NO, @"Child must implement");
}

- (void)handleTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSAssert(NO, @"Child must implement");
}

- (void)handleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSAssert(NO, @"Child must implement");
}

- (void)handleTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSAssert(NO, @"Child must implement");
}

- (BOOL) respondsToTouches
{
    return self.isEnabled;
}

+ (instancetype) createAndAttachToNode:(SKNode *)node
{
    return [[self class] createAndAttachToNode:node Key:PLUGIN_KEY_TOUCH_HANDLER];
}
@end
