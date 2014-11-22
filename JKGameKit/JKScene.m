//
//  JKScene.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKNodeProtocol.h"
#import "JKPluginProtocol.h"
#import "JKScene.h"

@interface JKScene()
@property (nonatomic) NSHashTable* nodesToAdd;
@property (nonatomic) NSTimeInterval lastUpdateInterval;
@property (nonatomic) NSTimeInterval dtLimit;
- (void) registerNode:(SKNode*) node;
- (void) unregisterNode:(SKNode*) node;
@end

@implementation JKScene

- (instancetype) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        _nodesToAdd = [NSHashTable weakObjectsHashTable];
        _subscribedNodes = [NSHashTable weakObjectsHashTable];
        _subscribedPlugins = [NSHashTable weakObjectsHashTable];
        _lastUpdateInterval = 0.0;
        _dtLimit = 0.1;
    }
    return self;
}

- (void) update:(CFTimeInterval)currentTime
{
    if (self.lastUpdateInterval > 0)
    {
        _dt = MIN(currentTime - self.lastUpdateInterval, self.dtLimit);
    }
    self.lastUpdateInterval = currentTime;
    
    // Add pending nodes
    if (self.nodesToAdd.count > 0)
    {
        NSHashTable* tmp = [self.nodesToAdd copy];
        [self.nodesToAdd removeAllObjects];
        
        for (SKNode* node in tmp)
        {
            if ([node conformsToProtocol:@protocol(JKNodeProtocol)] && !((id<JKNodeProtocol>)node).hasEnteredScene && !((id<JKNodeProtocol>)node).hasExitedScene)
            {
                [(id<JKNodeProtocol>)node onEnter];
            }
        }
        [tmp removeAllObjects];
    }
    
    // Pass update signal to subscribed nodes
    for (id<JKNodeProtocol> node in self.subscribedNodes)
    {
        [(id<JKNodeProtocol>)node onUpdate:_dt];
    }
    
    // Pass update signal to subscribed plugins
    for (id<JKPluginProtocol> plugin in self.subscribedPlugins)
    {
        if ([(id<JKPluginProtocol>)plugin isEnabled])
        {
            [(id<JKPluginProtocol>)plugin onUpdate:_dt];
        }
    }
}

- (void) addChild:(SKNode *)node
{
    [super addChild:node];
    [self recursiveAddNode:node];
}

- (void) insertChild:(SKNode *)node atIndex:(NSInteger)index
{
    [super insertChild:node atIndex:index];
    [self recursiveAddNode:node];
}

- (void) removeAllChildren
{
    [self removeChildrenInArray:self.children];
}

- (void) removeChildrenInArray:(NSArray *)nodes
{
    for (SKNode* node in nodes)
    {
        [self recursiveRemoveNode:node];
    }
}

- (void) recursiveAddNode:(SKNode*)node
{
    [self registerNode:node];
    for (SKNode* child in node.children)
    {
        [self recursiveAddNode:child];
    }
}

- (void) recursiveRemoveNode:(SKNode*)node
{
    if ([node conformsToProtocol:@protocol(JKNodeProtocol)])
    {
        [self unregisterNode:node];
        for (SKNode* child in node.children)
        {
            [child removeFromParent];
        }
    }
}

- (void) registerNode:(SKNode*)node
{
    [self.nodesToAdd addObject:node];
    
    if ([node respondsToSelector:@selector(onUpdate:)])
    {
        [self.subscribedNodes addObject:node];
    }
    
    [node.userData enumerateKeysAndObjectsUsingBlock:^(id key, id plugin, BOOL* stop)
     {
         if ([plugin conformsToProtocol:@protocol(JKPluginProtocol)] && [plugin respondsToSelector:@selector(onUpdate:)])
         {
             [self.subscribedPlugins addObject:plugin];
         }
     }];
}

- (void) unregisterNode:(SKNode*)node
{    
    [self.subscribedNodes removeObject:node];
    
    [node.userData enumerateKeysAndObjectsUsingBlock:^(id key, id plugin, BOOL* stop)
     {
         if ([plugin conformsToProtocol:@protocol(JKPluginProtocol)] && [plugin respondsToSelector:@selector(onUpdate:)])
         {
             [self.subscribedPlugins removeObject:plugin];
         }
     }];
}

@end
