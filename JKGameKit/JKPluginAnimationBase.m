//
//  JKPluginAnimationBase.m
//  JKGameKit
//
//  Created by Jussi Kallio on 4.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKSpriteNode.h"
#import "JKGameNode.h"
#import "JKPluginAnimationBase.h"

static NSString* kAnimKey = @"ActionKeyAnimation";

@implementation JKPluginAnimationBase

+ (SKAction*) createAnimationWithFrames:(NSArray*)frames Freq:(float)freq Revert:(BOOL)revert
{
    NSMutableArray* frameList = [NSMutableArray arrayWithArray:frames];
    if (revert)
    {
        NSArray* reverseFrames = [[frames reverseObjectEnumerator] allObjects];
        if (reverseFrames.count > 2)
        {
            for (int i=1; i < reverseFrames.count-1; ++i)
            {
                [frameList addObject:[reverseFrames objectAtIndex:i]];
            }
        }
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frameList timePerFrame:freq resize:YES restore:YES]];
}

- (void) onNodeEnter
{
    JKAssert([self.node isKindOfClass:[JKSpriteNode class]], @"Node is not SpriteNode");
    JKAssert([self.node.parent isKindOfClass:[JKGameNode class]], @"Parent is not GameNode");
}

- (instancetype) initWithNode:(SKNode<JKNodeProtocol> *)node
{
    if (self = [super initWithNode:node])
    {
        JKAssert([node isKindOfClass:[JKSpriteNode class]], @"Invalid class type");
        _actions = [NSMutableDictionary dictionary];
        _activeAnimID = [NSNumber numberWithInteger:-1];
        _idleAnimID = [NSNumber numberWithInteger:-1];
    }
    return self;
}

- (void) changeAnimation:(NSNumber*)animID
{
    if ([animID isEqualToNumber:self.activeAnimID] == NO)
    {
        [self runAnimation:[self.actions objectForKey:animID]];
        self.activeAnimID = animID;
    }
}

- (void) runAnimation:(SKAction*)action
{
    [[JKSpriteNode cast:self.node] runAction:action withKey:kAnimKey];
}

- (void) stopAnimation
{
    [[JKSpriteNode cast:self.node] removeActionForKey:kAnimKey];
    self.activeAnimID = [NSNumber numberWithInteger:-1];
}

+ (instancetype) createAndAttachToNode:(SKNode *)node
{
    return [[self class] createAndAttachToNode:node Key:PLUGIN_KEY_ANIMATION];
}

@end
