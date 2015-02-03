//
//  JKGameScene.h
//  JKGameKit
//
//  Created by Jussi Kallio on 3.11.2014.
//  Copyright (c) 2014 Kallio. All rights reserved.
//

#import "JKScene.h"
@class JKWorldNode;
@class JKHudNode;
@class JKGameNode;
@class JKNodeFactory;

@interface JKGameScene : JKScene <SKPhysicsContactDelegate>

@property (nonatomic, weak) JKWorldNode* world;
@property (nonatomic, weak) JKHudNode* hud;
@property (nonatomic, weak) JKGameNode* activeNode;
@property (nonatomic) JKNodeFactory* nodeFactory;

+ (instancetype) sceneWithSize:(CGSize)size Level:(JKWorldNode*) level;
- (instancetype) initWithSize:(CGSize)size Level:(JKWorldNode*) level;
- (void) pause;
- (void) resume;
- (void) endGame;
- (void) startGame;

- (void) switchToLevel:(JKWorldNode*)level Delay:(NSTimeInterval)delay;
- (void) levelLoaded;

@end
