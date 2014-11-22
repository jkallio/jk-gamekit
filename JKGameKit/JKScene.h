//
//  JKScene.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JKScene : SKScene

@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) NSHashTable* subscribedNodes;
@property (nonatomic) NSHashTable* subscribedPlugins;

- (void) recursiveAddNode:(SKNode*) node;
- (void) recursiveRemoveNode:(SKNode*) node;

@end
