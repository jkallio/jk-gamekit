//
//  JKPluginBase.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKScene.h"
#import "JKGameScene.h"
#import "JKGameNode.h"
#import "JKSpriteNode.h"
#import "JKWorldNode.h"
#import "JKPluginBase.h"

@implementation JKPluginBase
@synthesize gameNode = _gameNode;
@synthesize spriteNode = _spriteNode;

- (instancetype) init
{
    NSAssert(NO, @"No default init");
    return [super init];
}

- (instancetype) initWithNode:(SKNode<JKNodeProtocol>*) node
{
    if (self = [super init])
    {
        _node = node;
        _isEnabled = YES;
    }
    return self;
}

- (JKGameScene*) gameScene
{
    if (!_gameScene && [self.node.scene isKindOfClass:[JKGameScene class]])
    {
        _gameScene = (JKGameScene*)self.node.scene;
    }
    return _gameScene;
}

- (JKGameNode*) gameNode
{
    if (!_gameNode)
    {
        _gameNode = [JKGameNode cast:self.node];
    }
    return _gameNode;
}

- (JKSpriteNode*) spriteNode
{
    if (!_spriteNode)
    {
        _spriteNode = [JKSpriteNode cast:self.node];
    }
    return _spriteNode;
}

- (JKWorldNode*) world
{
    return self.gameScene.world;
}

- (JKHudNode*) hud
{
    return self.gameScene.hud;
}

+ (instancetype) createAndAttachToNode:(SKNode *)node
{
    JKAssert(NO, @"TODO: Impelent in child class");
    return nil;
}

+ (instancetype) createAndAttachToNode:(SKNode*)node Key:(NSString*)key
{
    if (node.userData == nil)
    {
        node.userData = [NSMutableDictionary dictionary];
    }
    
    id plugin = [[[self class] alloc] initWithNode:(SKNode<JKNodeProtocol>*)node];
    [node.userData setObject:plugin forKey:key];
    
    return plugin;
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
