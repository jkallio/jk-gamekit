//
//  PluginTouchDispatcher.m
//  GigaMan
//
//  Created by Jussi Kallio on 6.10.2014.
//  Copyright (c) 2014 Jussi Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKGameScene.h"
#import "JKWorldNode.h"
#import "JKHudNode.h"
#import "JKPluginTouchDispatcher.h"
#import "JKPluginTouchHandlerBase.h"

@interface JKPluginTouchDispatcher()
@property (nonatomic) NSMutableDictionary* activeHandlers;
@property (nonatomic) CGPoint prevLocation;

- (JKPluginTouchHandlerBase*) touchHandlerFor:(UITouch *)touch;
- (JKPluginTouchHandlerBase*) touchHandlerFor:(UITouch *)touch InNode:(SKNode *)node;
- (JKPluginTouchHandlerBase*) touchHandlerFor:(NSSet*)touches Event:(UIEvent*)event;
@end

@implementation JKPluginTouchDispatcher

- (void)dispatchTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        JKPluginTouchHandlerBase* handler = [self touchHandlerFor:touch];
        if (handler)
        {
            [handler handleTouchesBegan:touches withEvent:event];
            
            if (!self.activeHandlers)
            {
                self.activeHandlers = [NSMutableDictionary new];
            }
            [self.activeHandlers setObject:handler forKey:[NSNumber numberWithUnsignedInteger:touch.hash]];
        }
    }
}

- (void)dispatchTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    JKPluginTouchHandlerBase* handler = [self.activeHandlers objectForKey:[NSNumber numberWithUnsignedInteger:touch.hash]];
    if (handler)
    {
        [handler handleTouchesMoved:touches withEvent:event];
    }
}

- (void)dispatchTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    JKPluginTouchHandlerBase* handler = [self.activeHandlers objectForKey:[NSNumber numberWithUnsignedInteger:touch.hash]];
    if (handler)
    {
        [handler handleTouchesEnded:touches withEvent:event];
        [self.activeHandlers removeObjectForKey:[NSNumber numberWithUnsignedInteger:touch.hash]];
    }
}

- (void)dispatchTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    JKPluginTouchHandlerBase* handler = [self.activeHandlers objectForKey:[NSNumber numberWithUnsignedInteger:touch.hash]];
    if (handler)
    {
        [handler handleTouchesCancelled:touches withEvent:event];
        [self.activeHandlers removeObjectForKey:[NSNumber numberWithUnsignedInteger:touch.hash]];
    }
}

- (JKPluginTouchHandlerBase*) touchHandlerFor:(UITouch*)touch
{
    JKPluginTouchHandlerBase* handler = nil;
    if (self.hud)
    {
        handler = [self touchHandlerFor:touch InNode:self.hud];
    }
    
    if (!handler && self.world)
    {
        handler = [self touchHandlerFor:touch InNode:self.world];
    }
    
    if (!handler)
    {
        handler = [self touchHandlerFor:touch InNode:self.gameScene];
    }
    
    if (!handler)
    {
        handler = [self.node.scene.userData objectForKey:@"PluginTouchHandler"];
    }
    
    return handler;
}

- (JKPluginTouchHandlerBase*) touchHandlerFor:(UITouch *)touch InNode:(SKNode *)node
{
    CGPoint location = [(SKView*)touch.view convertPoint:[touch locationInView:touch.view] toScene:self.node.scene];
    
    JKPluginTouchHandlerBase* handler = nil;
    for (SKNode* nodeAtPoint in [node nodesAtPoint:[self.node convertPoint:location toNode:node]])
    {
        JKPluginTouchHandlerBase* tmp = [nodeAtPoint.userData objectForKey:@"PluginTouchHandler"];
        if (tmp && [tmp respondsToTouches])
        {
            handler = tmp;
            break;
        }
    }
    return handler;
}

- (JKPluginTouchHandlerBase*) touchHandlerFor:(NSSet*)touches Event:(UIEvent*)event
{
    JKPluginTouchHandlerBase* handler = nil;
    if (self.hud)
    {
        handler = [self touchHandlerFor:[touches anyObject] InNode:self.hud];
    }
    
    if (!handler && self.world)
    {
        handler = [self touchHandlerFor:[touches anyObject] InNode:self.world];
    }
    
    if (!handler)
    {
        handler = [self touchHandlerFor:[touches anyObject] InNode:self.gameScene];
    }
    
    if (!handler)
    {
        handler = [self.node.scene.userData objectForKey:@"PluginTouchHandler"];
    }
    
    return handler;
}

+ (instancetype) createAndAttachToNode:(SKNode*)node
{
    if (node.userData == nil)
    {
        node.userData = [NSMutableDictionary dictionary];
    }
    id plugin = [[[self class] alloc] initWithNode:(SKNode<JKNodeProtocol>*)node];
    [node.userData setObject:plugin forKey:PLUGIN_KEY_TOUCH_DISPATCHER];
    
    node.userInteractionEnabled = YES;
    if ([node isKindOfClass:[SKScene class]])
    {
        if ([((SKScene*)node).view isKindOfClass:[SKView class]])
        {
            ((SKView*)((SKScene*)node).view).multipleTouchEnabled = YES;
            ((SKView*)((SKScene*)node).view).exclusiveTouch = YES;
        }
    }
    return plugin;
}

@end
