//
//  JKPhysicsContactHandler.m
//  JKGameKit
//
//  Created by Jussi Kallio on 10.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKDefines.h"
#import "JKGameNode.h"
#import "JKPluginContactHandlerBase.h"

@implementation JKPluginContactHandlerBase

- (void) contactBeganWith:(JKGameNode*)nodeB
{
    JKDebugLog(@"Contact began with %@ at point %@", nodeB.name, NSStringFromCGPoint(nodeB.position));
}

- (void) contactEndedWith:(JKGameNode*)nodeB
{
    JKDebugLog(@"Contact ended with %@ at point %@", nodeB.name, NSStringFromCGPoint(nodeB.position));
}

+ (instancetype) createAndAttachToNode:(SKNode *)node
{
    return [[self class] createAndAttachToNode:node Key:PLUGIN_KEY_CONTACT_HANDLER];
}

@end

