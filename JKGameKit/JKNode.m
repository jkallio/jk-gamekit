//
//  JKNode.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKScene.h"
#import "JKGameScene.h"
#import "JKWorldNode.h"
#import "JKHudNode.h"
#import "JKPluginProtocol.h"
#import "JKNode.h"

@implementation JKNode

- (instancetype) init
{
    if (self = [super init])
    {
        _hasEnteredScene = NO;
        _hasExitedScene = NO;
    }
    return self;
}

- (void) onEnter
{
    self.hasEnteredScene = YES;
    self.hasExitedScene = NO;
    
    for (SKNode* child in self.children)
    {
        if ([child conformsToProtocol:@protocol(JKNodeProtocol)] && [(id<JKNodeProtocol>)child hasEnteredScene] == NO)
        {
            [(id<JKNodeProtocol>)child onEnter];
        }
    }
    
    [self.userData enumerateKeysAndObjectsUsingBlock:^(id key, id plugin, BOOL* stop)
     {
         if ([plugin conformsToProtocol:@protocol(JKPluginProtocol)] && [plugin respondsToSelector:@selector(onNodeEnter)])
         {
             [plugin onNodeEnter];
         }
     }];
}

- (void) onExit
{
    self.hasEnteredScene = NO;
    self.hasExitedScene = YES;
    
    for (SKNode* child in self.children)
    {
        if ([child conformsToProtocol:@protocol(JKNodeProtocol)] && [(id<JKNodeProtocol>)child hasExitedScene] == NO)
        {
            [(id<JKNodeProtocol>)child onExit];
        }
    }
    
    [self.userData enumerateKeysAndObjectsUsingBlock:^(id key, id plugin, BOOL* stop)
     {
         if ([plugin conformsToProtocol:@protocol(JKPluginProtocol)] && [plugin respondsToSelector:@selector(onNodeExit)])
         {
             [plugin onNodeExit];
         }
     }];
}

- (void) addChild:(SKNode *)node
{
    [super addChild:node];
    [(JKScene*)self.scene recursiveAddNode:node];
}

- (void) insertChild:(SKNode *)node atIndex:(NSInteger)index
{
    [super insertChild:node atIndex:index];
    [(JKScene*)self.scene recursiveAddNode:node];
}

- (void) removeChildrenInArray:(NSArray *)nodes
{
    for (SKNode* node in nodes)
    {
        [(JKScene*)self.scene recursiveRemoveNode:node];
    }
}

- (void) removeAllChildren
{
    for (SKNode* node in self.children)
    {
        [(JKScene*)self.scene recursiveRemoveNode:node];
    }
}

- (void) removeFromParent
{
    [self.gameScene recursiveRemoveNode:self];
    [self onExit];
    [super removeFromParent];
}

- (JKGameScene*) gameScene
{
    if (!_gameScene && [self.scene isKindOfClass:[JKGameScene class]])
    {
        _gameScene = (JKGameScene*)self.scene;
    }
    return _gameScene;
}

- (JKWorldNode*) world
{
    return self.gameScene.world;
}

- (JKHudNode*) hud
{
    return self.gameScene.hud;
}

+ (instancetype)cast:(id)from
{
    if ([from isKindOfClass:[self class]])
    {
        return from;
    }
    return nil;
}

@end
