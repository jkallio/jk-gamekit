//
//  JKGameScene.m
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKUtils.h"
#import "JKTextureCache.h"
#import "JKNodeProtocol.h"
#import "JKPluginProtocol.h"
#import "JKPluginContactHandlerBase.h"
#import "JKPluginTouchDispatcher.h"
#import "JKWorldNode.h"
#import "JKHudNode.h"
#import "JKCameraNode.h"
#import "JKGameNode.h"
#import "JKSpriteNode.h"
#import "JKGameScene.h"

@interface JKGameScene()
@property (nonatomic, weak) JKWorldNode* nextLevel;
@property (nonatomic, weak) JKSpriteNode* levelChangeCurtain;
@property (nonatomic) NSTimeInterval levelChangeDelay;
@property (nonatomic) NSTimeInterval currentTime;
@property (nonatomic) BOOL isLevelSwitchTime;
- (void) doSwitchLevel;
- (void) centerOnNode:(SKNode*)node;
@end

@implementation JKGameScene

- (instancetype) initWithSize:(CGSize)size
{
    NSAssert(NO, @"Level not specified!");
    return [super initWithSize:size];
}

+ (instancetype) sceneWithSize:(CGSize)size Level:(JKWorldNode*) level
{
    id scene = [[[self class] alloc] initWithSize:size Level:level];
    return scene;
}

- (instancetype) initWithSize:(CGSize)size Level:(JKWorldNode*)level
{
    if (self = [super initWithSize:size])
    {
        self.name = @"GameScene";

        _levelChangeDelay = DBL_MAX;
        _isLevelSwitchTime = NO;
        
        JKSpriteNode* curtain = [JKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:size];
        curtain.position = CGPointMake(size.width/2, size.height/2);
        curtain.name = @"LevelChangeCurtain";
        curtain.zPosition = FLT_MAX;
        [self addChild:curtain];
        curtain.alpha = 0.0f;
        self.levelChangeCurtain = curtain;
        
        [JKPluginTouchDispatcher createAndAttachToNode:self];
        [self.physicsWorld setContactDelegate:self];
        
        [self switchToLevel:level Delay:0.0f];
    }
    return self;
}

- (void) levelLoaded
{
    [self.levelChangeCurtain runAction:[SKAction fadeOutWithDuration:0.5f]];
}

- (void) update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    if (self.isLevelSwitchTime && currentTime > self.levelChangeDelay)
    {
        JKDebugLog(@"It's time to switch stage");
        [self doSwitchLevel];
        self.isLevelSwitchTime = NO;
        self.levelChangeDelay = DBL_MAX;
    }
    
    [self centerOnNode:self.world.camera];
    self.currentTime = currentTime;
}

- (void) pause
{
    for (id<JKNodeProtocol> node in self.subscribedNodes)
    {
        if ([node respondsToSelector:@selector(onGamePause)])
        {
            [(id<JKNodeProtocol>)node onGamePause];
        }
    }
    
    for (id<JKPluginProtocol> plugin in self.subscribedPlugins)
    {
        if ([(id<JKPluginProtocol>)plugin isEnabled] && [plugin respondsToSelector:@selector(onGamePause)])
        {
            [(id<JKPluginProtocol>)plugin onGamePause];
        }
    }
}

- (void) resume
{
    for (id<JKNodeProtocol> node in self.subscribedNodes)
    {
        if ([node respondsToSelector:@selector(onGameResume)])
        {
            [(id<JKNodeProtocol>)node onGameResume];
        }
    }
    
    for (id<JKPluginProtocol> plugin in self.subscribedPlugins)
    {
        if ([(id<JKPluginProtocol>)plugin isEnabled] && [plugin respondsToSelector:@selector(onGameResume)])
        {
            [(id<JKPluginProtocol>)plugin onGameResume];
        }
    }
}

- (void) endGame
{
    for (id<JKNodeProtocol> node in self.subscribedNodes)
    {
        if ([node respondsToSelector:@selector(onGameOver)])
        {
            [(id<JKNodeProtocol>)node onGameOver];
        }
    }
    
    for (id<JKPluginProtocol> plugin in self.subscribedPlugins)
    {
        if ([plugin respondsToSelector:@selector(onGameOver)])
        {
            [(id<JKPluginProtocol>)plugin onGameOver];
        }
    }
}

- (void) startGame
{
    for (id<JKNodeProtocol> node in self.subscribedNodes)
    {
        if ([node respondsToSelector:@selector(onGameBegin)])
        {
            [(id<JKNodeProtocol>)node onGameBegin];
        }
    }
    
    for (id<JKPluginProtocol> plugin in self.subscribedPlugins)
    {
        if ([plugin respondsToSelector:@selector(onGameBegin)])
        {
            [(id<JKPluginProtocol>)plugin onGameBegin];
        }
    }
}

- (void) switchToLevel:(JKWorldNode*)level Delay:(NSTimeInterval)delay
{
    if (!self.isLevelSwitchTime)
    {
        JKDebugLog(@"Switching to stage %@", level.class);
        self.nextLevel = level;
        [self addChild:level];
        
        [self.levelChangeCurtain runAction:[SKAction fadeInWithDuration:0.5f]];
        self.levelChangeDelay = self.currentTime + delay;
        self.isLevelSwitchTime = YES;
    }
}

- (void) doSwitchLevel
{
    if (self.world)
    {
        [self.world removeFromParent];
        self.world = nil;
    }
    if (self.hud)
    {
        [self.hud removeFromParent];
        self.hud = nil;
    }
    
    self.world = self.nextLevel;
    [self.world LoadLevel];
    [self levelLoaded];
    [__sharedTextureCache purgeTextureCache];
    
    self.nextLevel = nil;
    
    JKHudNode* hud = [self.world loadHUD];
    if (hud)
    {
        [self addChild:hud];
        self.hud = hud;
    }
}

- (void) centerOnNode:(SKNode *)node
{
    CGPoint posInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    posInScene = CGPointMake(node.parent.position.x - posInScene.x, node.parent.position.y - posInScene.y);
    node.parent.position = CGPointAdd(MidPoint(self.frame), posInScene);
}

#pragma mark --
#pragma mark ContactDispatcher
- (void) didBeginContact:(SKPhysicsContact *)contact
{
    if (!self.world.isPaused)
    {
        JKDebugLogVerbose(@"Contact ended: A:%@ - B:%@", contact.bodyA.node.name, contact.bodyB.node.name);
        JKPluginContactHandlerBase* contactHandlerA = [contact.bodyA.node.userData objectForKey:PLUGIN_KEY_CONTACT_HANDLER];
        if (contactHandlerA && [contact.bodyB.node isKindOfClass:[JKGameNode class]])
        {
            [contactHandlerA contactBeganWith:(JKGameNode*)contact.bodyB.node];
        }
        
        JKPluginContactHandlerBase* contactHandlerB = [contact.bodyB.node.userData objectForKey:PLUGIN_KEY_CONTACT_HANDLER];
        if (contactHandlerB && [contact.bodyA.node isKindOfClass:[JKGameNode class]])
        {
            [contactHandlerB contactBeganWith:(JKGameNode*)contact.bodyA.node];
        }
    }
}

- (void) didEndContact:(SKPhysicsContact *)contact
{
    if (!self.world.isPaused)
    {
        JKDebugLogVerbose(@"Contact ended: A:%@ - B:%@", contact.bodyA.node.name, contact.bodyB.node.name);
        JKPluginContactHandlerBase* contactHandlerA = [contact.bodyA.node.userData objectForKey:PLUGIN_KEY_CONTACT_HANDLER];
        if (contactHandlerA && [contact.bodyB.node isKindOfClass:[JKGameNode class]])
        {
            [contactHandlerA contactEndedWith:(JKGameNode*)contact.bodyB.node];
        }
        
        JKPluginContactHandlerBase* contactHandlerB = [contact.bodyB.node.userData objectForKey:PLUGIN_KEY_CONTACT_HANDLER];
        if (contactHandlerB && [contact.bodyA.node isKindOfClass:[JKGameNode class]])
        {
            [contactHandlerB contactEndedWith:(JKGameNode*)contact.bodyA.node];
        }
    }
}

#pragma mark --
#pragma mark TouchDispatcher
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.userData objectForKey:@"PluginTouchDispatcher"] dispatchTouchesBegan:touches withEvent:(UIEvent*)event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.userData objectForKey:@"PluginTouchDispatcher"] dispatchTouchesMoved:touches withEvent:(UIEvent*)event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.userData objectForKey:@"PluginTouchDispatcher"] dispatchTouchesEnded:touches withEvent:(UIEvent*)event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.userData objectForKey:@"PluginTouchDispatcher"] dispatchTouchesCancelled:touches withEvent:(UIEvent*)event];
}

@end
